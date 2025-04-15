module PostsHelper
  def render_user_posts(user)
    content = []

    # Posts list
    if user.posts.any?
      content << safe_join(
        user.posts.map { |post| render("posts/postcard", post: post) }
      )
    end

    safe_join(content)
  end
end
