module ApplicationHelper
  def body_class
    classes = []
    classes << "#{controller_name}-#{action_name}"  # e.g. "books-index"
    # classes << "#{controller_name}-controller"      # e.g. "books-controller"
    classes.join(" ")
  end

  def user_navbar_content
    if authenticated?
      content_tag(:div, class: "navbar-dropdown") do
        concat(
          content_tag(:button, class: "navbar-dropdown-toggle") do
            link_to Current.user.nickname, user_path(Current.user.id), class: "navbar-dropdown-item"
          end
        )
        concat(
          content_tag(:div, class: "navbar-dropdown-menu") do
            if Current.user.club.nil?
              concat(link_to "Become a Curator", new_club_path, class: "navbar-dropdown-item")
            else
              concat(link_to Current.user.club.name, club_path(Current.user.club), class: "navbar-dropdown-item")
            end
            concat(link_to "Edit user", edit_user_path(Current.user.id), class: "navbar-dropdown-item")
            concat(button_to "Logout", logout_path, method: :delete, class: "navbar-dropdown-item")
          end
        )
      end
    else
      safe_join([
        link_to("Login", new_session_path, class: "navbar-link"),
        link_to("Register", new_user_path, class: "navbar-link")
      ], "\n")
    end
  end

  # navbar search form
  def render_search_form
    content_tag :div, class: "search-form-wrapper" do
      form_tag(search_path, method: :get, class: "search-form") do
        safe_join([
          text_field_tag(:query, params[:query], placeholder: "Cerca...", class: "search-input"),
            button_tag(type: "submit", class: "btn btn--secondary") do
              render_icon_image("magnifying_glass")
            end
        ])
      end
    end
  end

  # display icon
  def render_icon_image(name)
    if File.exist?(Rails.root.join("app", "assets", "images", "icons", "#{name}.png"))
      image_tag("icons/#{name}.png", alt: name.to_s.humanize, class: "icon-image", size: "32x32")
    else
      content_tag(:span, name.to_s.humanize, class: "missing-icon")
    end
  end
end
