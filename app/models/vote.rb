class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :poll
  belongs_to :poll_option

  validates :user_id, uniqueness: { scope: :poll_id }
  validate :poll_active
  validate :user_belongs_to_club

  private

  def poll_active
    return if poll.active?

    errors.add(:base, "Voting has ended for this poll")
  end

  def user_belongs_to_club
    return if Membership.exists?(follower: user, club: poll.club)

    errors.add(:follower, "must be a member of the club to vote")
  end
end
