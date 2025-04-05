class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :omni_auth_identities, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  validates :email_address, presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_sensitive: false }
  validates :password, on: [ :registration, :password_change ],
            presence: true,
            length: { minimum: 8, maximum: 72 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def self.create_from_oauth(auth)
    email = auth.info.email
    user = self.new email_address: email, password: SecureRandom.base64(64).truncate_bytes(64)
    # TODO: you could save additional information about the user from the OAuth sign in
    # assign_names_from_auth(auth, user)
    user.save
    user
  end

  def signed_in_with_oauth(auth)
    # TODO: same as above, you could save additional information about the user
    # User.assign_names_from_auth(auth, self)
    # save if first_name_changed? || last_name_changed?
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
end
