class Membership < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :club, class_name: "Club"
  validates :follower_id, presence: true
  validates :club_id, presence: true
end
