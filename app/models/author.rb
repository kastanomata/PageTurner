class Author < ApplicationRecord
  # Associations
  belongs_to :account, class_name: "User", foreign_key: "account_id", optional: true
  has_many :books, dependent: :nullify

  # Validations
  validates :name, presence: true
  validates :openlibrary_id, uniqueness: true, allow_nil: true

  # Scopes
  scope :alphabetical, -> { order(name: :asc) }
  scope :with_account, -> { where.not(account_id: nil).joins(:account) }
  scope :without_account, -> { where(account_id: nil) }
  scope :with_valid_account, -> {
    where.not(account_id: nil)
          .joins("INNER JOIN users ON authors.account_id = users.id")
  }

  # Instance methods
  def book_count
    books.count
  end

  def to_s
    name
  end
end
