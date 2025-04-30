class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :books, through: :taggings

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :popular, ->(limit = 5) {
    left_joins(:taggings)
      .group(:id)
      .order("COUNT(taggings.id) DESC")
      .limit(limit)
  }
end
