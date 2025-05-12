class BookSuggestion < ApplicationRecord
  belongs_to :club
  belongs_to :book
  belongs_to :user

  validates :club_id, uniqueness: { scope: :book_id, message: "This book has already been suggested" }
  validates :user_id, presence: true
end
