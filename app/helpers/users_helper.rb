module UsersHelper
  include OwnershipUtility
  def user_description(user)
    if user.description.present?
      content_tag(:p, user.description, class: "user-description")
    else
      content_tag(:p, "This user seems shy...", class: "user-description shy")
    end
  end

  def make_author_request(user)
    if user.author_request.blank?
      render_author_request_form(user)
    else
      render_author_request_status(user)
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
    elements[2] = book_image(book, size: "thumbnail")
    elements[1] = content_tag(:div, class: "book-info") do
            link_to(book.title, book_path(book), class: "btn btn--link book-title")
            end

    content_tag(:div, safe_join(elements), class: "currently-reading")
  end

  def render_author_request_form(user)
    content_tag(:div, class: "form-container") do
      form_with(model: user, url: update_author_request_user_path(user), method: :patch) do |form|
        content_tag(:h2, "Author Information", class: "title") +
        content_tag(:div, class: "form-group") do
          form.label(:author_request, "OpenLibrary Author ID", class: "form-label") +
            form.text_field(:author_request, class: "form-control", placeholder: "Enter your OpenLibrary author ID") +
            tag.br +
            content_tag(:small, "This links your account to your author profile on OpenLibrary.", class: "form-text text-muted")
        end +
        content_tag(:div, class: "form-actions") do
          form.submit("Save Author ID", class: "btn btn--primary")
        end
      end
    end
  end

  def render_author_request_status(user)
    content_tag(:div, class: "author-status") do
      content_tag(:h2, "Author Request Status", class: "title") +
      content_tag(:p, "You've already submitted a request to be identified as an author.", class: "author-status-text") +
      content_tag(:p, "Your OpenLibrary Author ID: #{user.author_request}", class: "author-id") +
      button_to("Cancel Author Request", 
                update_author_request_user_path(user, user: { author_request: nil }), 
                method: :patch, 
                class: "btn btn--negative",
                data: { confirm: "Are you sure you want to cancel your author request?" })
    end
  end
end
