module AuthorsHelper
  def author_details(author_id)
    @author_details ||= {}
    return @author_details[author_id] if @author_details.key?(author_id)

    # Fetch with deep=1 for full details
    details = BookApiService.fetch_author_details(author_id, 1)

    # Add fallbacks for missing data
    details[:bio] ||= "No biography available"
    details[:thumbnail] ||= image_path("author_placeholder.png")
    details[:portrait] ||= details[:thumbnail]

    @author_details[author_id] = details
  end
end
