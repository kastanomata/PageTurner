module AuthorsHelper
  def author_details(author_id)
    @author_details ||= {}
    return @author_details[author_id] if @author_details.key?(author_id)

    # Fetch with deep=1 for full details
    details = BookApiService.fetch_author_details(author_id, 2)

    details
  end

  def author_heading_with_metadata(author, details, options = {})
    # Default options
    options.reverse_merge!(
      alternate_names_limit: 3,
      show_full_name: true,
      show_alternate_names: true
    )

    # Main content blocks
    content_blocks = []

    # Author name heading
    content_blocks << content_tag(:h2, author.name, class: "author-name")

    # Full name if available
    if options[:show_full_name] && details[:fuller_name].present?
      content_blocks << content_tag(:p, class: "author-full-name") do
        content_tag(:strong, "Full name: ") + details[:fuller_name]
      end
    end

    # Alternate names if available
    if options[:show_alternate_names] && details[:alternate_names].present? && details[:alternate_names].any?
      names_to_show = details[:alternate_names].first(options[:alternate_names_limit])
      names_display = names_to_show.join(", ")

      if details[:alternate_names].size > options[:alternate_names_limit]
        names_display += content_tag(:span, "...", class: "author-names-ellipsis")
      end

      content_blocks << content_tag(:div, class: "author-section author-alternate-names") do
        content_tag(:strong, "Also known as: ") +
        content_tag(:span, names_display.html_safe, class: "author-names-inline")
      end
    end

    # Combine all content blocks
    safe_join(content_blocks)
  end
end
