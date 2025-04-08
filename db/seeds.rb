include InitializeUtility
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
# Clear existing data to avoid duplicates


clear_existing_data
seed_users
puts "Seeded #{User.count} users."
seed_books
puts "Seeded #{Book.count} books."
seed_posts
puts "Seeded #{Post.count} posts."
seed_bookclubs
puts "Seeded #{Club.count} bookclubs."
seed_bookshelves
puts "Seeded #{Bookshelf.count} bookshelves."
seed_bookshelf_contains
puts "Seeded #{BookshelfContain.count} books in bookshelves."
initialize_tables
puts "Initialized Special Bookshelves, Relationships and Memberships."

puts "Seeding completed."
