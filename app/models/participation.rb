class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user_id, uniqueness: { scope: :event_id }
  validates :status, inclusion: { in: %w[registered attended cancelled] }

  # Scopes
  scope :registered, -> { where(status: "registered") }
  scope :attended, -> { where(status: "attended") }
  scope :cancelled, -> { where(status: "cancelled") }
end
