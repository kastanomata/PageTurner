class Author < ApplicationRecord
  # Associations
  belongs_to :account, class_name: "User", foreign_key: "account_id", optional: true
  has_many :books, dependent: :nullify
  has_many :events, as: :organizer, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :openlibrary_id, uniqueness: true, allow_nil: true
  validate :event_times_must_be_valid, if: -> { events.any? }

  # Scopes
  scope :alphabetical, -> { order(name: :asc) }
  scope :with_account, -> { where.not(account_id: nil).joins(:account) }
  scope :without_account, -> { where(account_id: nil) }
  scope :with_valid_account, -> {
    where.not(account_id: nil)
          .joins("INNER JOIN users ON authors.account_id = users.id")
  }
  scope :with_upcoming_events, -> {
    joins(:events)
      .where("events.start_time > ?", Time.current)
      .distinct
  }
  scope :with_past_events, -> {
    joins(:events)
      .where("events.start_time <= ?", Time.current)
      .distinct
  }

  # Instance methods
  def book_count
    books.count
  end

  def to_s
    name
  end

  def upcoming_events
    events.upcoming.order(:start_time)
  end

  def next_event
    upcoming_events.first
  end

  def past_events
    events.past.order(start_time: :desc)
  end

  def create_event(attributes)
    events.create(attributes.merge(organizer: self))
  end

  private

  def event_times_must_be_valid
    events.each do |event|
      if event.end_time && event.end_time < event.start_time
        errors.add(:base, "Event #{event.title} has invalid time range")
      end
    end
  end
end
