module RelationshipsHelper
  def render_user_relationships_widget(user)
    safe_join([
      render("shared/user_stats"),
      (render("relationships/follow_form", user: user) if logged_in?)
    ].compact)
  end
end
