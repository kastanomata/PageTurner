include InitializeUtility
class User < ApplicationRecord
  has_one_attached :avatar
  has_secure_password

  validates :nickname, uniqueness: { case_sensitive: false }

  has_many :sessions, dependent: :destroy
  has_many :omni_auth_identities, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :active_memberships, class_name:  "Membership", foreign_key: "follower_id", dependent: :destroy
  has_many :partecipates, through: :active_memberships, source: :club

  # has_many :posts, dependent: :change ???
  has_many :likes, dependent: :destroy

  has_many :bookshelves, dependent: :destroy, foreign_key: "creator_id"
  has_many :bookshelf_contains, through: :bookshelves, dependent: :destroy
  has_one :club, foreign_key: "curator_id", dependent: :destroy

  # has_many :reports, dependent: :change ???

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
    # you could save additional information about the user from the OAuth sign in
    # assign_names_from_auth(auth, user)
    user.save
    InitializeUtility.initialize_user(user)
    user
  end

  def signed_in_with_oauth(auth)
    # same as above, you could save additional information about the user
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

  # Becomes a member of a club.
  def becomes_member(club)
    active_membership.create(club_id: club.id)
  end

  # Unsubscribes from a club.
  def unsubscribes(club)
    active_membership.find_by(club_id: club.id).destroy
  end

  # Returns true if the current user is a member of the club.
  def is_member?(club)
    partecipates.include?(club)
  end

  # Creates a bookshelf for the user
  def create_bookshelf(name:, club: nil, special: false)
    bookshelf = Bookshelf.new(name: name, creator: self, bookclub: club, special: special)
    bookshelf.save
    bookshelf
  end

  def get_special_bookshelves
    bookshelves.where(bookclub: nil, special: true)
  end

  def curator_club
    Club.find_by(curator_id: id)
  end
end
