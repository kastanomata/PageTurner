class Ban < ApplicationRecord
  belongs_to :user
  belongs_to :moderator, class_name: "User"
  validates :reason, presence: true
end
