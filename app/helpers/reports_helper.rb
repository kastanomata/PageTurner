module ReportsHelper
  REPORTABLE_OWNERS = {
    Club => :curator,
    Post => :author,
    Comment => :author,
    User => :itself
  }.freeze

  def render_report_button(reported)
    return unless authenticated?

    owner_association = REPORTABLE_OWNERS[reported.class] || :user
    return unless reported.respond_to?(owner_association)

    owner = reported.public_send(owner_association)
    return if owner == Current.user
    render "reports/report_button", reported: reported
  end

  def render_report_card(report)
    # TODO Add button to ban owner of reported item
    content_tag(:div, class: "report-card", style: "display: flex; justify-content: space-between; align-items: center; padding: 10px; border: 1px solid #ccc; border-radius: 5px; margin-bottom: 10px;", id: dom_id(report)) do
      safe_join([
        render_report_info(report),
        render_created_at(report),
        render_report_actions(report)
      ])
    end
  end

  private

  def render_report_info(report)
    reporter = User.find(report.reporter_id)
    content_tag(:div, class: "report-info", style: "display: flex; flex-direction: column;") do
      safe_join([
        content_tag(:span) do
          safe_join([
            content_tag(:strong, "Reporter: "),
            link_to(reporter.nickname, user_path(reporter)),
            " (#{reporter.email_address})"
          ])
        end,
        render_reported_content(report)
      ])
    end
  end

  def render_reported_content(report)
    return content_tag(:span, "Reported content has been deleted", class: "text-muted") unless report.reported

    case report.reported_type
    when "Post"
      safe_join([
        content_tag(:span) do
          safe_join([
            content_tag(:strong, "Reported Post: "),
            link_to(report.reported.title.truncate(100), post_path(report.reported))
          ])
        end,
        content_tag(:span) do
          safe_join([
            content_tag(:strong, "Author: "),
            link_to(report.reported.author.nickname, user_path(report.reported.author))
          ])
        end
      ])
    when "User"
      content_tag(:span) do
        safe_join([
          content_tag(:strong, "Reported User: "),
          link_to(report.reported.nickname, user_path(report.reported))
        ])
      end
    when "Club"
      content_tag(:span) do
        safe_join([
          content_tag(:strong, "Reported Club: "),
          link_to(report.reported.name, club_path(report.reported))
        ])
      end
    when "Comment"
      content_tag(:span) do
        safe_join([
          content_tag(:strong, "Reported Comment: "),
          link_to(report.reported.text.truncate(100), comment_path(report.reported))
        ])
      end
    else
      content_tag(:span) do
        safe_join([
          content_tag(:strong, "Reported #{report.reported.class.name}: "),
          link_to("View #{report.reported.class.name.downcase}", report.reported)
        ])
      end
    end
  end

  def render_created_at(report)
    content_tag(:div, class: "report-created-at", style: "margin-left: auto; text-align: right;") do
      content_tag(:span) do
        safe_join([
          content_tag(:strong, "Created At: "),
          report.created_at.strftime("%B %d, %Y %H:%M")
        ])
      end
    end
  end

  def render_report_actions(report)
    content_tag(:div, class: "report-actions", style: "display: flex; gap: 10px;") do
      button_to("Delete", report_path(report),
                method: :delete,
                data: { confirm: "Are you sure?" },
                class: "btn btn--delete",
                style: "padding: 5px 10px;")
    end
  end
end
