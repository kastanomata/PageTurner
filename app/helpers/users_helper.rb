module UsersHelper
  OWNER_ASSOCIATIONS = {
    Post => :author,
    Club => :curator,
    Comment => :user,
    User => :itself  # For comparing user profiles
    # Add other models as needed
  }.freeze

  def current_user_owns?(content)
    return false unless Current.user && content

    owner_method = OWNER_ASSOCIATIONS[content.class] || :user
    return false unless content.respond_to?(owner_method)

    owner = content.public_send(owner_method)
    owner == Current.user
  end
end
