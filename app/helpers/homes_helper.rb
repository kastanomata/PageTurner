module HomesHelper
  def render_homepage_posts(user)
    posts = Post.where(author_id: user.following_ids).order(created_at: :desc)
    content = [ content_tag(:h2, "Post Recenti") ]

    if posts.any?
      list_content = render(partial: "posts/postcard", collection: posts, as: :post)
      content << content_tag(:ul, list_content)
    else
      content << content_tag(:p, "Nessun post disponibile.")
    end

    safe_join(content)
  end

  def render_search_form
    content_tag :div, class: "search-container" do
      form_tag(search_path, method: :get) do
        safe_join([
          text_field_tag(:query, params[:query], placeholder: "Cerca..."),
          submit_tag("Cerca")
        ])
      end
    end
  end
end
