class Report < ApplicationRecord
  belongs_to :reporter, class_name: "User" # Reporter is a User
  belongs_to :reported, polymorphic: true  # Automatically handles reported_id and reported_type

  validates :reported_type, inclusion: { in: %w[User Post Comment Club] } # Restrict allowed types
  validates :reporter, :reported, presence: true
end
