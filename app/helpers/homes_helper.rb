module HomesHelper
  def render_homepage_based_on_authentication
    if authenticated?
      render "homepage"
    else
      render "guestpage"
    end
  end
  # this renders the homepage posts specific to the logged-in user
  def render_homepage_posts(user)
    posts = Post.where(author_id: user.following_ids).order(created_at: :desc)
    content = []

    if posts.any?
      list_content = render(partial: "posts/post_card", collection: posts, as: :post)
      # FIXME is there a better way to avoid the space to the left?
      content << content_tag(:ul, list_content, style: "margin-left: -2.5em;")
    else
      content << content_tag(:p, "Nessun post disponibile.")
    end

    safe_join(content)
  end
  
end
