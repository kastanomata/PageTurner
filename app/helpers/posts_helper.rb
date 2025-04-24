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

  def post_management_buttons(post)
    return unless Current.user && (Current.user.admin? || post_owner?(post))

    content_tag(:div, style: "display: flex; gap: 10px;") do
      safe_join([
        edit_post_button(post),
        destroy_post_button(post)
      ])
    end
  end

  private

  def post_owner?(post)
    post.author == Current.user
  end

  def edit_post_button(post)
    return unless post_owner?(post)

    link_to "Edit this post", edit_post_path(post), class: "btn-edit"
  end

  def destroy_post_button(post)
    button_to "Destroy this post", post,
              method: :delete,
              class: "btn-link-red btn-destroy",
              form: { data: { turbo_confirm: "Are you sure?" } }
  end
end
