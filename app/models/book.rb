class Book < ApplicationRecord
  validates :isbn, presence: true, uniqueness: true
  belongs_to :author
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :reading_goals, dependent: :destroy
  has_many :clubs, through: :reading_goals
  has_many :book_suggestions, dependent: :destroy
  has_many :suggesting_clubs, through: :book_suggestions, source: :club

  has_many :current_readers,
  class_name: "User",
  foreign_key: "book_id"

  def self.find_or_create_by_isbn!(isbn)
    book = find_by(isbn: isbn)
    return book if book

    api_data = BookApiService.fetch_by_isbn(isbn)
    raise "Book not found" if api_data[:error]

    create!(
      isbn: isbn,
      title: api_data[:title],
      cover_url: api_data[:cover_url]
    )
  end

  def process_open_library_tags(api_tags)
    return if api_tags.blank?

    Tag.transaction do
      api_tags.each do |tag_name|
        tag = Tag.find_or_create_by(name: tag_name)
        taggings.find_or_create_by(tag: tag)
      end
    end
  end
end
