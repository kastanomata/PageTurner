class Book < ApplicationRecord
  validates :isbn, presence: true, uniqueness: true

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
end
