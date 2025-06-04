class ReadingGoal < ApplicationRecord
  belongs_to :club
  belongs_to :book

  delegate :curator, to: :club, prefix: true

  validates :start_date, :end_date, presence: true
  validate :end_date_after_start_date
  validate :only_one_active_goal_per_club, if: :active?

  # Scope to get all reading goals for a specific club
  scope :for_club, ->(club) { where(club_id: club.id) }

  # Scope to get past reading goals for a club (end_date is in the past)
  scope :past_goals, -> { where("end_date < ?", Time.current) }

  # Scope to get current reading goals (end_date is in the future)
  scope :current, -> { where("end_date >= ?", Time.current) }

  # Check if this goal is currently active
  def active?
    end_date.present? && end_date >= Time.current
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    errors.add(:end_date, "must be after start date") if end_date < start_date
  end

  def only_one_active_goal_per_club
    if club.reading_goals.current.where.not(id: id).exists?
      errors.add(:base, "There can only be one active reading goal per club")
    end
  end

  # Class method to get current reading goal for a club
  def self.current_for_club(club)
    club.reading_goals.current.first
  end

  # Class method to get past reading goals for a club
  def self.past_goals_for_club(club)
    club.reading_goals.past_goals
  end
end
