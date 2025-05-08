class Club < ApplicationRecord
  belongs_to :curator, class_name: "User"
  after_save :update_curator_status

  has_many :bookshelves, foreign_key: "bookclub", dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :reading_goals, dependent: :destroy
  has_many :books, through: :reading_goals
  has_many :book_suggestions, dependent: :destroy
  has_many :suggested_books, through: :book_suggestions, source: :book
  has_many :polls, dependent: :destroy

  validates :name, presence: true

  has_many :passive_memberships, class_name: "Membership", foreign_key: "club_id", dependent: :destroy
  has_many :members, through: :passive_memberships, source: :follower

  has_many :reports, as: :reported, dependent: :destroy # TODO add memory of reports on comment deletion

  # Becomes a member of a club.
  def becomes_member(user)
    passive_memberships.create(follower_id: user.id)
  end

  # Unsubscribes from a club.
  def unsubscribes(user)
    passive_memberships.find_by(follower_id: user.id).destroy
  end

  # Returns true if the current user is a member of the club.
  def is_member?(user)
    members.include?(user)
  end

  def members_count
    passive_memberships.count
  end

  def expiring_polls
    polls.where("expires_at > ?", Time.current)
         .or(polls.where(expires_at: nil))
  end

  private

  def update_curator_status
    # Set current curator status
    if curator_id_previously_changed?
      # Clear previous curator status if needed
      old_curator = User.find_by(id: curator_id_previous_change.first)
      if old_curator && old_curator.clubs.empty?
        old_curator.update(is_curator: false)
      end

      # Set new curator status
      curator.update(is_curator: true) if curator
    end
  end
end
