class Poll < ApplicationRecord
  belongs_to :club
  delegate :curator, to: :club, prefix: true
  has_many :poll_options, dependent: :destroy
  has_many :books, through: :poll_options
  has_many :votes, dependent: :destroy
  validates :expires_at, presence: true

  accepts_nested_attributes_for :poll_options, allow_destroy: true, reject_if: :all_blank

  def time_remaining
    return 0 if expired?
    (expires_at - Time.current).to_i
  end

  def active?
    expires_at.present? && expires_at > Time.current.in_time_zone(Time.zone)
  end

  def curator
    club_curator
  end
end
