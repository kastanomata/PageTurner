module OwnershipUtility
  OWNER_ASSOCIATIONS = {
    Post => :author,
    Bookshelf => :creator,
    Club => :curator,
    Comment => :user,
    User => :itself
  }.freeze

  def current_user_owns?(content)
    return false unless Current.user && content

    owner_method = OWNER_ASSOCIATIONS[content.class] || :user
    return false unless content.respond_to?(owner_method)

    content.public_send(owner_method) == Current.user
  end
end
