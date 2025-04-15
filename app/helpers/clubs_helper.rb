module ClubsHelper
  def render_user_clubs(user)
    return unless user # Handle nil user case

    content = [ content_tag(:h3, "Curators") ]

    list_items = []

    # Add user's curator club if present
    if (your_club = user.curator_club).present?
      list_items << content_tag(:li) do
        safe_join([
          link_to("You (#{user.nickname})", user_path(user)),
          " - ",
          link_to(your_club.name, club_path(your_club))
        ])
      end
    end

    # Add active memberships
    user.active_memberships.each do |membership|
      list_items << content_tag(:li) do
        safe_join([
          link_to(membership.club.curator.nickname, user_path(membership.club.curator)),
          " - ",
          link_to(membership.club.name, club_path(membership.club))
        ])
      end
    end

    content << content_tag(:div, class: "curator-list") do
      content_tag(:ul, safe_join(list_items))
    end

    safe_join(content)
  end
end
