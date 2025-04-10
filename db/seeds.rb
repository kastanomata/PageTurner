# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
#

include InitializeUtility
include SeedingUtility

# Clear existing data to avoid duplicates
def clear_existing_data
  User.destroy_all
  Book.destroy_all
  Post.destroy_all
  Bookshelf.destroy_all
  BookshelfContain.destroy_all
  Club.destroy_all
  Relationship.destroy_all
  Membership.destroy_all
  puts "Cleared existing data..."
end

# clear_existing_data
seed_users
puts "Seeded #{User.count} users."
seed_books
puts "Seeded #{Book.count} books."
seed_clubs
puts "Seeded #{Club.count} bookclubs."
seed_bookshelves
puts "Seeded #{Bookshelf.count} bookshelves."
seed_posts
puts "Seeded #{Post.count} posts."
initialize_tables
puts "Initialized Special Bookshelves, Relationships and Memberships."

puts "Seeding completed."
