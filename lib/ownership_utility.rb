module OwnershipUtility
  OWNER_ASSOCIATIONS = {
    Post => :author,
    Bookshelf => :creator,
    Club => :curator,
    Comment => :user,
    User => :itself,
    Membership => :follower,
    Like => :user,
    Relationship => :follower,
    Poll => :curator,
    Event => :organizer
  }.freeze

  def current_user_owns?(content)
    return false unless Current.user && content

    # Find the owner association method or default to nil
    owner_method = OWNER_ASSOCIATIONS[content.class]
    return false unless owner_method && content.respond_to?(owner_method)

    # Special case for User resource
    if content.is_a?(User)
      content == Current.user
    else
      content.public_send(owner_method) == Current.user
    end
  end
end
