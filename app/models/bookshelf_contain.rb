class BookshelfContain < ApplicationRecord
  belongs_to :name, class_name: "Bookshelf"
  belongs_to :creator, class_name: "User"
  belongs_to :book
end
