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
    return if user.reading.nil?
    book = Book.find(user&.reading_id)
    return unless book

    content_tag(:div, class: "currently-reading") do
      safe_join([
        content_tag(:div, class: "book-cover") do
          if book.cover
            image_tag(book.cover, alt: "#{book.title} cover")
          else
            image_tag("bookart_not_found.png",
                     alt: "Default book cover")
          end
        rescue
          image_tag("bookart_not_found.png",
                   alt: "Default book cover")
        end,

        content_tag(:div, class: "book-info") do
          link_to(book.title, book_path(book),
            class: "book-title")
        end
      ])
    end
  end

  def user_ban_status(user)
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
              class: "btn btn-success btn--sm"
    else
      link_to "BAN", new_user_ban_path(user),
              class: "btn btn-warning btn--sm"
    end
  end
end
