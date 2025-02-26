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
User.destroy_all
Post.destroy_all
Book.destroy_all

# Users
# create_table "users", force: :cascade do |t|
#   t.string "email"
#   t.string "nickname"
#   t.string "description"
#   t.string "birthday"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
# end

# Seed data for three users
users = [
  {
    email: "AntonioTurco@example.com",
    nickname: "kastanomata",
    description: "This is the first user.",
    birthday: "1990-01-01",
    created_at: Time.now,
    updated_at: Time.now
  },
  {
    email: "AlessandroTemperini@example.com",
    nickname: "AleNino",
    description: "This is the second user.",
    birthday: "1995-05-15",
    created_at: Time.now,
    updated_at: Time.now
  },
  {
    email: "AlfredoSegala@example.com",
    nickname: "Fredo",
    description: "This is the third user.",
    birthday: "1985-12-25",
    created_at: Time.now,
    updated_at: Time.now
  }
]

# Create users in the database
users.each do |user_attributes|
  User.create!(user_attributes)
end

# Post
# create_table "posts", force: :cascade do |t|
#   t.string "title"
#   t.string "text"
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
#   t.string "creator"
# end

# Seed data for 10 posts with book ISBNs
posts = [
  # Posts by the first user (AntonioTurco@example.com)
  { title: "Thoughts on Game of Thrones", text: "Game of Thrones is an epic tale of power and betrayal. The characters are complex and the plot is unpredictable.", creator: "AntonioTurco@example.com", book: "9780553381689", created_at: Time.now, updated_at: Time.now },
  { title: "Review of Fifty Shades of Grey", text: "Fifty Shades of Grey is a controversial book with a unique take on romance. It's not for everyone, but it has its moments.", creator: "AntonioTurco@example.com", book: "9789350835616", created_at: Time.now, updated_at: Time.now },
  { title: "Charlotte's Web: A Classic", text: "Charlotte's Web is a heartwarming story about friendship and loyalty. It's a must-read for children and adults alike.", creator: "AntonioTurco@example.com", book: "9780060006983", created_at: Time.now, updated_at: Time.now },
  { title: "Game of Thrones: A Masterpiece", text: "The world-building in Game of Thrones is unparalleled. Every detail is meticulously crafted, making it a truly immersive experience.", creator: "AntonioTurco@example.com", book: "9780553381689", created_at: Time.now, updated_at: Time.now },
  { title: "Fifty Shades of Grey: My Thoughts", text: "While Fifty Shades of Grey has its flaws, it also has an intriguing storyline that keeps you hooked.", creator: "AntonioTurco@example.com", book: "9789350835616", created_at: Time.now, updated_at: Time.now },

  # Posts by the second user (AlessandroTemperini@example.com)
  { title: "Game of Thrones: A Review", text: "The political intrigue in Game of Thrones is fascinating. It's a gripping read from start to finish.", creator: "AlessandroTemperini@example.com", book: "9780553381689", created_at: Time.now, updated_at: Time.now },
  { title: "Fifty Shades of Grey: An Opinion", text: "Fifty Shades of Grey explores themes of power and control in relationships. It's a bold and daring book.", creator: "AlessandroTemperini@example.com", book: "9789350835616", created_at: Time.now, updated_at: Time.now },
  { title: "Charlotte's Web: A Review", text: "Charlotte's Web is a timeless classic that teaches valuable lessons about friendship and sacrifice.", creator: "AlessandroTemperini@example.com", book: "9780060006983", created_at: Time.now, updated_at: Time.now },
  { title: "Game of Thrones: My Take", text: "The character development in Game of Thrones is exceptional. Each character has a unique and compelling story arc.", creator: "AlessandroTemperini@example.com", book: "9780553381689", created_at: Time.now, updated_at: Time.now },
  { title: "Fifty Shades of Grey: A Review", text: "Fifty Shades of Grey is a provocative book that challenges societal norms. It's a thought-provoking read.", creator: "AlessandroTemperini@example.com", book: "9789350835616", created_at: Time.now, updated_at: Time.now }
]

# Create posts in the database
posts.each do |post_attributes|
  Post.create!(post_attributes)
end

# Seed data for books
books = [
  { isbn: "9780553381689" },
  { isbn: "9789350835616" },
  { isbn: "9780060006983" }
]

books.each do |book_attributes|
  book_details = BookApiService.fetch_book_details(book_attributes[:isbn])
  Book.create!(isbn: book_attributes[:isbn], title: book_details[:title], thumbnail: book_details[:thumbnail])
end

puts "Seeded #{users.size} users, #{posts.size} posts and #{books.size} books."
