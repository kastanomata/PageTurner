module ParticipationsHelper
  def render_event_participation_widget(event)
    safe_join([
      link_to(
        "#{event.participations.count} participants",
        event_participations_path(event), # Assuming you have this route
        class: "btn btn--link",
        id: "participants_count"
      ),
      (render("participations/participation_form", event: event) if logged_in?)
    ].compact)
  end
end
