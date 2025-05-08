module AuthorRequestsHelper
  def pending_author_requests
    User.where.not(author_request: [ nil, "" ]).order(created_at: :desc)
  end

  def author_request_action_links(user)
    {
      accept_path: accept_author_request_path(user),
      deny_path: deny_author_request_path(user)
    }
  end
end
