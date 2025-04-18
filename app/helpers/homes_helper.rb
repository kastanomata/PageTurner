module HomesHelper
  # this renders the homepage posts specific to the logged-in user
  def render_homepage_posts(user)
    posts = Post.where(author_id: user.following_ids).order(created_at: :desc)
    content = [ content_tag(:h2, "Post Recenti") ]

    if posts.any?
      list_content = render(partial: "posts/post_card", collection: posts, as: :post)
      content << content_tag(:ul, list_content)
    else
      content << content_tag(:p, "Nessun post disponibile.")
    end

    safe_join(content)
  end
  
end
