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
end
