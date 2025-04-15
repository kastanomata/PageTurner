module ClubsHelper
  def render_user_clubs(user)
    return unless user # Handle nil user case

    content = [ content_tag(:h3, "Curators") ]

    clubs_data = []

    # Add user's curator club if present
    if (your_club = user.curator_club).present?
      clubs_data << {
        club: your_club,
        curator: user,
        is_current_user: true
      }
    end

    # Add active memberships
    user.active_memberships.each do |membership|
      clubs_data << {
        club: membership.club,
        curator: membership.club.curator,
        is_current_user: false
      }
    end

    content << content_tag(:div, class: "club-list") do
      safe_join(
        clubs_data.map do |data|
          render partial: "clubs/club_card",
                 locals: {
                   club: data[:club],
                   curator: data[:curator],
                   is_current_user: data[:is_current_user]
                 }
        end
      )
    end

    safe_join(content)
  end
end
