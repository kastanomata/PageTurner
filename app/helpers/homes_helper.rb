module HomesHelper
  def render_homepage_based_on_authentication
    if authenticated?
      render "homepage"
    else
      render "guestpage"
    end
  end

  def render_homepage_posts(user)
    # Posts from users the current user follows
    following_posts = Post.where(author_id: user.following_ids)
                        .order(created_at: :desc)

    # Posts from clubs the user is a member of
    memberships_posts = Post.where(club_id: user.partecipates.ids)
                          .order(created_at: :desc)

    # Combine both post collections, remove duplicates, and sort by creation date
    posts = (following_posts.to_a | memberships_posts.to_a)
            .sort_by(&:created_at)
            .reverse

    content = []

    if posts.any?
      list_content = render(partial: "posts/post_card", collection: posts.uniq, as: :post)
      content << content_tag(:ul, list_content, class: "homepage-content")
    else
      content << content_tag(:p, "Nessun post disponibile.")
    end

    # Wrap everything in a homepage-content container
    content_tag(:div, safe_join(content), class: "homepage-content")
  end
end
