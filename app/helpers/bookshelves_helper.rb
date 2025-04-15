module BookshelvesHelper
  def render_user_bookshelves(user)
    content_tag :div, class: "bookshelves" do
      safe_join(
        user.bookshelves.map do |bookshelf|
          class_name = bookshelf.is_user_bound?(user) ? "special-bookshelf bookshelf" : "bookshelf"

          content_tag :div, class: class_name do
            safe_join([
              content_tag(:h3, bookshelf.name),
              content_tag(:p, "Created at: #{bookshelf.created_at.strftime("%B %d, %Y")}"),
              link_to("Show this bookshelf", bookshelf)
            ])
          end
        end
      )
    end
  end
end
