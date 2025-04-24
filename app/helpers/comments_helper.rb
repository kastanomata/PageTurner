module CommentsHelper
  def comments_section(post)
    content_tag(:div) do
      safe_join([
        content_tag(:h3, "Comments"),
        authentication_prompt,
        comments_content(post)
      ])
    end
  end

  private

  def authentication_prompt
    if authenticated?
      content_tag(:div) do
        render "comments/form", comment: Comment.new
      end
    else
      content_tag(:div) do
        link_to "Log in to comment!", login_path
      end
    end
  end

  def comments_content(post)
    return no_comments_message unless post.comments.any?

    content_tag(:div) do
      safe_join([
        content_tag(:br),
        comments_list(post.comments.includes(:user)),
        content_tag(:br)
      ])
    end
  end

  def comments_list(comments)
    content_tag(:div) do
      safe_join(comments.map { |comment| comment_item(comment) })
    end
  end

  def comment_item(comment)
    return unless comment.author_id.present?
    
    content_tag(:div) do
      safe_join([
        content_tag(:span, comment.user.nickname, class: "comment-author"),
        content_tag(:span, comment.text, class: "comment-text")
      ])
    end
  end

  def no_comments_message
    content_tag(:div) do
      content_tag(:p, "No comments yet.")
    end
  end
end