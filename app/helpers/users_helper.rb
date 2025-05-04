module UsersHelper
  include OwnershipUtility
  def user_description(user)
    if user.description.present?
      content_tag(:p, user.description, class: "user-description")
    else
      content_tag(:p, "This user seems shy...", class: "user-description shy")
    end
  end

  def currently_reading(user)
    if user&.reading_id.present?
      render_currently_reading user
    else
      content_tag(:h3, "#{user.nickname} is not reading any book at the moment.", class: "currently-reading currently-reading-header")
    end
  end

  def user_ban_status(user)
    unless authenticated? and admin?
      return
    end
    if user.active_ban
      content_tag(:span, class: "ban-status banned") do
        if user.permanently_banned?
          "PERMANENTLY BANNED"
        else
          "TEMPORARILY BANNED (Expires: #{user.active_ban.expires_at.to_formatted_s(:short)})"
        end
      end
    else
      content_tag(:span, "ACTIVE", class: "ban-status active")
    end
  end

  def ban_unban_button(user)
    if user.active_ban
      button_to "UNBAN", user_ban_path(user_id: user.id, id: user.active_ban.id),
              method: :delete,
              data: { confirm: "Unban #{user.nickname}?" },
              class: "btn btn--affirmative btn--sm"
    else
      link_to "BAN", new_user_ban_path(user),
              class: "btn btn--negative btn--sm"
    end
  end

  private

  def render_currently_reading(user)
    book = Book.find_by(id: user&.reading_id)
    return unless book
    elements = []
    elements[0] = content_tag(:h3, "#{user.nickname} is currently reading...", class: "currently-reading-header")
    elements[2] = book_image(book, size:"thumbnail")
    elements[1] = content_tag(:div, class: "book-info") do
            link_to(book.title, book_path(book), class: "btn btn--link book-title")
            end

    content_tag(:div, safe_join(elements), class: "currently-reading")
  end

end
