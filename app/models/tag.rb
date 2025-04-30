class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :books, through: :taggings

  # validates :name, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
