class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :book, class_name: "Book"
  belongs_to :club, class_name: "Club", optional: true
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :reports, as: :reported, dependent: :destroy # TODO add memory of reports on post deletion
end
