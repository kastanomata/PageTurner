module TagsHelper
  def render_popular_tags(popular_tags)
    content_tag(:div, class: "popular-tags") do
      concat content_tag(:h3, "Popular Tags:")

      if popular_tags.any?
        content_tag(:div, class: "tag-list") do
          safe_join(
            popular_tags.map do |tag|
              content_tag(:span, class: "tag badge bg-secondary") do
                link_to(tag.name, tag_path(tag), class: "text-white text-decoration-none")
              end
            end
          )
        end
      else
        content_tag(:p, "No popular tags available", class: "text-muted")
      end
    end
  end
end
