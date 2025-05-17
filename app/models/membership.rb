class Membership < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :club, class_name: "Club"
  validates :follower_id, presence: true
  validates :club_id, presence: true

  before_destroy :prevent_curator_membership_deletion

  private

  def prevent_curator_membership_deletion
    if club.curator_id == follower_id
      errors.add(:base, "Curator's membership cannot be revoked")
      throw :abort
    end
  end
end
