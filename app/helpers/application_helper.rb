module ApplicationHelper
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
            image_tag("magnifying_glass.png", alt: "Search", class: "search-icon", size: "16x16")
            end
        ])
      end
    end
  end
end
