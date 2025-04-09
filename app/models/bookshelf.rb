class Bookshelf < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :bookshelf_contains, dependent: :destroy
  has_many :books, through: :bookshelf_contains

  validates :name, presence: true, uniqueness: { scope: [ :creator ] }
  # validates :description, length: { maximum: 255 }

  def add_book(book)
    BookshelfContain.create!(bookshelf: self, book: book)
  end

  def remove_book(book)
    BookshelfContain.find_by(bookshelf: self, book: book).destroy
  end

  def Books
    books = []
    bookshelf_contains.each do |bookshelf_contain|
      books << bookshelf_contain.book
    end
    books
  end

  def contains?(book)
    Books.include?(book)
  end

  def is_user_bound?(user)
    # Check if the bookshelf is bound to the user
    self.name == "#{user.nickname}'s Read Books" || self.name == "#{user.nickname}'s Liked Books"
  end
end
