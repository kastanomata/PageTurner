module TagsHelper
  def display_tags(tags, limit: 8)
    return content_tag(:p, "No tags yet", class: "text-muted") if tags.empty?

    content_tag(:div, class: "tags") do
      content_tag(:h3, "Tags") +
      content_tag(:div, class: "tag-list") do
        safe_join(
          tags.first(limit).map do |tag|
            link_to(tag.name, tag_path(tag), class: "tag")
          end
        )
      end
    end
  end
end
