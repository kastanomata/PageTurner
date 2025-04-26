class BookshelfContain < ApplicationRecord
  belongs_to :bookshelf, class_name: "Bookshelf"
  belongs_to :book
  validates_uniqueness_of :book_id, scope: :bookshelf_id,
  message: "This book is already in the bookshelf"
end
