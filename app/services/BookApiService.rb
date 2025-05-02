# app/services/book_api_service.rb
require "net/http"
require "json"
class BookApiService
  BASE_URL = "https://openlibrary.org/api/books"
  allowed_tags_filepath = Rails.root.join("app", "services", "subjects_to_tags.csv")
  @allowed_tags = CSV.read(allowed_tags_filepath, headers: false).map { |row| [ row[0].downcase, row[1].downcase ] } unless File.exist?(allowed_tags_filepath)

  def self.fetch_book_details(isbn)
    begin
      # https://openlibsrary.org/api/books?bibkeys=ISBN:9780547928227&format=json&jscmd=data
      url = URI("#{BASE_URL}?bibkeys=ISBN:#{isbn}&format=json&jscmd=data")
      response = Net::HTTP.get(url)
      return {} if response.empty?
      data = JSON.parse(response)
      book_data = data["ISBN:#{isbn}"]
      work_openlibrary_url = book_data.dig("works", 0, "key")
      work_openlibrary_id = work_openlibrary_url.match(%r{/works/(OL[^/]+)})[1] if work_openlibrary_id
      author_openlibrary_url = book_data.dig("authors", 0, "url")
      author_openlibrary_id = author_openlibrary_url&.split("/")
      author_openlibrary_id = author_openlibrary_id[4] unless author_openlibrary_id.nil?
      tags = extract_and_normalize_tags(book_data)
      if book_data
        {
          openlibrary_id: work_openlibrary_id,
          author_openlibrary_id: author_openlibrary_id,
          title: book_data["title"],
          thumbnail: book_data.dig("cover", "small"),
          cover: book_data.dig("cover", "medium"),
          poster: book_data.dig("cover", "large"),
          tags: tags
        }
      end
    rescue JSON::ParserError, URI::InvalidURIError, Net::HTTPError => e
      Rails.logger.error "Book fetch error: #{e.message}"
      {}
    end
  end

  def self.fetch_author_details(openlibrary_id, deep = 0)
    begin
      url = URI("https://openlibrary.org/authors/#{openlibrary_id}.json")
      response = Net::HTTP.get(url)
      return {} if response.empty?

      author_data = JSON.parse(response)
      if deep == 0
        {
        openlibrary_id: openlibrary_id,
        name: author_data["name"]
        }
      elsif deep == 1
        {
        openlibrary_id: openlibrary_id,
        name: author_data["name"],
        bio: author_data["bio"] || "No biography available",
        birth_date: author_data["birth_date"],
        death_date: author_data["death_date"],
        photos: author_data["photos"] || [],
        thumbnail: author_photo_url(author_data["photos"], :small),
        portrait: author_photo_url(author_data["photos"], :medium)
        }
      end
    rescue JSON::ParserError, URI::InvalidURIError, Net::HTTPError => e
      Rails.logger.error "Author fetch error: #{e.message}"
      {}
    end
  end

  private

  def self.author_photo_url(photos, size)
    return nil if photos.nil? || photos.empty?

    sizes = {
      small: "S",
      medium: "M"
    }

    "https://covers.openlibrary.org/a/olid/#{photos.first}-#{sizes[size]}.jpg"
  end

  def self.extract_and_normalize_tags(book_data)
    raw_tags = book_data.dig("subjects")&.pluck("name") || []
    log @allowed_tags
    raw_tags.map do |tag|
      normalized_tag = tag.downcase
                         .gsub(/\s+/, " ")
                         .gsub(/[^\w\s]/, "")
                         .strip
      category, subcategory = @allowed_tags.find { |cat, sub| tag.downcase.include?(cat) && tag.downcase.include?(sub) }
      if category && subcategory
        "#{category}:#{subcategory}"
      elsif @allowed_tags.flatten.include?(normalized_tag)
        normalized_tag
      end
    end.compact.uniq.reject(&:blank?)
  end
end
