# app/services/book_api_service.rb
require "net/http"
require "json"
class BookApiService
  BASE_URL = "https://openlibrary.org/api/books"
  def self.fetch_book_details(isbn)
    url = URI("#{BASE_URL}?bibkeys=ISBN:#{isbn}&format=json&jscmd=data")
    response = Net::HTTP.get(url)
    data = JSON.parse(response)
    book_data = data["ISBN:#{isbn}"]
    if book_data
      {
        title: book_data["title"],
        thumbnail: book_data.dig("cover", "medium")
      }
    else
      {}
    end
  end
end
