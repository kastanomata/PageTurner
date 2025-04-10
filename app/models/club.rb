class Club < ApplicationRecord
  belongs_to :curator, class_name: "User"
  has_many :bookshelves, foreign_key: "bookclub", dependent: :destroy

  has_many :passive_memberships, class_name: "Membership", foreign_key: "club_id", dependent: :destroy
  has_many :members, through: :passive_memberships, source: :follower

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
end
