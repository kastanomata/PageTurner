class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user, foreign_key: :author_id, class_name: "User"
  validates :user, presence: true
  validates :text, presence: true
end
