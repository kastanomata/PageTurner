class Club < ApplicationRecord
  belongs_to :curator, class_name: "User"
  after_save :update_curator_status

  # Associations
  has_many :bookshelves, foreign_key: "bookclub", dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :reading_goals, dependent: :destroy
  has_many :books, through: :reading_goals
  has_many :book_suggestions, dependent: :destroy
  has_many :suggested_books, through: :book_suggestions, source: :book
  has_many :polls, dependent: :destroy
  has_many :events, as: :organizer, dependent: :destroy

  has_many :passive_memberships, class_name: "Membership", foreign_key: "club_id", dependent: :destroy
  has_many :members, through: :passive_memberships, source: :follower
  has_many :reports, as: :reported, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :description, length: { maximum: 500 }
  validate :event_times_must_be_valid, if: -> { events.any? }

  # Callbacks
  after_create :add_creator_as_member
  after_create :create_default_bookshelf
  before_destroy :check_for_upcoming_events, prepend: true

  # Scopes
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

  # Instance Methods
  def becomes_member(user)
    passive_memberships.create(follower_id: user.id)
  end

  def unsubscribes(user)
    passive_memberships.find_by(follower_id: user.id).destroy
  end

  def is_member?(user)
    members.include?(user)
  end

  def members_count
    passive_memberships.count
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

  def add_creator_as_member
    passive_memberships.find_or_create_by(follower_id: curator_id)
  end

  def create_default_bookshelf
    bookshelves.create(name: "#{name}'s Books", special: true)
  end

  def expiring_polls
    polls.where("expires_at > ?", Time.current)
         .or(polls.where(expires_at: nil))
  end

  def update_curator_status
    if curator_id_previously_changed?
      old_curator = User.find_by(id: curator_id_previous_change.first)
      if old_curator && old_curator.clubs.empty?
        old_curator.update(is_curator: false)
      end
      curator.update(is_curator: true) if curator
    end
  end

  def event_times_must_be_valid
    events.each do |event|
      if event.end_time && event.end_time < event.start_time
        errors.add(:base, "Event #{event.title} has invalid time range")
      end
    end
  end

  def check_for_upcoming_events
    if events.upcoming.exists?
      errors.add(:base, "Cannot delete club with upcoming events")
      throw :abort
    end
  end
end
