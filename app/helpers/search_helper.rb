module SearchHelper
  def render_search_results(results)
    return content_tag(:p, "No search query provided") if results.values.all?(&:empty?)

    output = ActiveSupport::SafeBuffer.new

    results.each do |model_name, records|
      next if records.empty?

      output << content_tag(:h2, model_name.to_s.humanize.pluralize)
      output << content_tag(:div, class: "#{model_name}-results") do
        if records.any?
          render partial: "#{model_name}/search_result", collection: records, as: model_name.to_s.singularize.to_sym
        else
          content_tag(:p, "No #{model_name.to_s.humanize.downcase} found")
        end
      end
    end

    output
  end

  def search_result_item(item)
    case item
    when Author
      render "authors/search_result", author: item
    when Book
      render "books/search_result", book: item
    when Bookshelf
      render "bookshelves/search_result", bookshelf: item
    when Club
      render "clubs/search_result", club: item
    when Event
      render "events/search_result", event: item
    when Post
      render "posts/search_result", post: item
    when Tag
      render "tags/search_result", tag: item
    when User
      render "users/search_result", user: item
    else
      content_tag(:div, item.to_s)
    end
  end
end
