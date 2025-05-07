class PollOption < ApplicationRecord
  belongs_to :poll
  belongs_to :book
  has_many :votes, dependent: :destroy
end
