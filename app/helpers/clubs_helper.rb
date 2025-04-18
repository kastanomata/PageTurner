module ClubsHelper
  def render_user_clubs(user)
    return unless user

    content = []

    # Curator club section
    if (your_club = user.curator_club).present?
      content << content_tag(:h3, "Your Club", class: "section-heading")
      content << content_tag(:div, class: "club-list") do
        render partial: "clubs/club_card",
               locals: {
                 club: your_club,
                 curator: user,
                 is_current_user: true
               }
      end
    end

    # Memberships section
    memberships = user.active_memberships.includes(club: :curator)
    if memberships.any?
      content << content_tag(:h3, "Clubs You're a Member Of", class: "section-heading")
      content << content_tag(:div, class: "club-list") do
        safe_join(
          memberships.map do |membership|
            render partial: "clubs/club_card",
                   locals: {
                     club: membership.club,
                     curator: membership.club.curator,
                     is_current_user: false
                   }
          end
        )
      end
    end

    safe_join(content)
  end
end
