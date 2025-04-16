module PostsHelper
  def render_user_posts(user)
    content = []

    # Posts list
    if user.posts.any?
      content << safe_join(
        user.posts.map { |post| render("posts/post_card", post: post) }
      )
    end

    safe_join(content)
  end

  # Displays the number of likes with pluralization
  def display_likes_count(post)
    content_tag(:p, "#{post.likes.count} #{'Like'.pluralize(post.likes.count)}")
  end

  # Renders Like/Unlike button based on user's authentication and existing like
  def like_button(post)
    return unless authenticated?

    pre_like = post.likes.find { |like| like.user_id == Current.user&.id }

    if pre_like
      button_to "Unlike", post_like_path(post, pre_like), method: :delete
    else
      button_to "Like", post_likes_path(post), method: :post
    end
  end
end
