class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user, foreign_key: :author_id, class_name: "User"
  validates :user, presence: true
  validates :text, presence: true

  has_many :reports, as: :reported, dependent: :destroy # TODO add memory of reports on comment deletion
end
