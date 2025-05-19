class Event < ApplicationRecord
  belongs_to :book, optional: true
  belongs_to :organizer, polymorphic: true

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :start_time, presence: true
  validates :organizer_type, presence: true, inclusion: { in: %w[Club Author] }
  validates :organizer_id, presence: true

  validate :end_time_after_start_time
  validate :organizer_exists

  before_destroy :nullify_book_references, if: :book_id?

  scope :upcoming, -> { where("start_time > ?", Time.current).order(:start_time) }
  scope :past, -> { where("start_time <= ?", Time.current).order(start_time: :desc) }
  scope :for_club, ->(club) { where(organizer_type: "Club", organizer_id: club.id) }
  scope :for_author, ->(author) { where(organizer_type: "Author", organizer_id: author.id) }
  scope :organized_by, ->(organizer) {
    case organizer
    when Club
      where(organizer_type: "Club", organizer_id: organizer.id)
    when Author
      where(organizer_type: "Author", organizer_id: organizer.id)
    else
      none
    end
  }

  def organizer
    case organizer_type
    when "club"
      org = Club.find_by(id: organizer_id)&.curator
    when "author"
      org = User.find_by(author_id: organizer_id)
    else
      org = nil
    end
    org
  end

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time < start_time
      errors.add(:end_time, "must be after start time")
    end
  end

  def organizer_exists
    case organizer_type
    when "Club"
      errors.add(:organizer_id, "Club not found") unless Club.exists?(organizer_id)
    when "Author"
      errors.add(:organizer_id, "Author not found") unless Author.exists?(organizer_id)
    end
  end
end
