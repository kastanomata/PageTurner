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
def clear_existing_data
  User.destroy_all
  Post.destroy_all
  Book.destroy_all
  Bookshelf.destroy_all
  BookshelfContain.destroy_all
  puts "Cleared existing data."
end

# Seed data for users
def seed_users
  users = [
    {
      email_address: "antonioturco@example.com",
      password: "password",
      nickname: "kastanomata",
      description: "This is the first user.",
      birthday: "1990-01-01",
      created_at: Time.now,
      updated_at: Time.now
    },
    {
      email_address: "alessandrotemperini@example.com",
      password: "password",
      nickname: "AleNino",
      description: "This is the second user.",
      birthday: "1995-05-15",
      created_at: Time.now,
      updated_at: Time.now
    },
    {
      email_address: "alfredosegala@example.com",
      password: "password",
      nickname: "Fredo",
      description: "This is the third user.",
      birthday: "1985-12-25",
      created_at: Time.now,
      updated_at: Time.now
    }
  ]

  users.each do |user_attributes|
    User.create!(user_attributes)
  end
end

# Seed data for posts
def seed_posts
  posts = [
    # Posts by the first user (antonioturco@example.com)
    { title: "Thoughts on Game of Thrones", text: "Game of Thrones is an epic tale of power and betrayal. The characters are complex and the plot is unpredictable.", creator: "antonioturco@example.com", book: "9780553381689", created_at: Time.now, updated_at: Time.now },
    { title: "Review of Fifty Shades of Grey", text: "Fifty Shades of Grey is a controversial book with a unique take on romance. It's not for everyone, but it has its moments.", creator: "antonioturco@example.com", book: "9789350835616", created_at: Time.now, updated_at: Time.now },

    # Posts by the second user (alessandrotemperini@example.com)
    { title: "Charlotte's Web: A Review", text: "Charlotte's Web is a timeless classic that teaches valuable lessons about friendship and sacrifice.", creator: "alessandrotemperini@example.com", book: "9780060006983", created_at: Time.now, updated_at: Time.now },
    { title: "Game of Thrones: My Take", text: "The character development in Game of Thrones is exceptional. Each character has a unique and compelling story arc.", creator: "alessandrotemperini@example.com", book: "9780553381689", created_at: Time.now, updated_at: Time.now },
    { title: "Fifty Shades of Grey: A Review", text: "Fifty Shades of Grey is a provocative book that challenges societal norms. It's a thought-provoking read.", creator: "alessandrotemperini@example.com", book: "9789350835616", created_at: Time.now, updated_at: Time.now }
  ]

  posts.each do |post_attributes|
    post_attributes[:creator] = post_attributes[:creator].downcase
    Post.create!(post_attributes)
  end
end

# Seed data for books
def seed_books
  books = [
    { isbn: "9780553381689" },
    { isbn: "9789350835616" },
    { isbn: "9780060006983" },
    { isbn: "9780451524935" }, # 1984 by George Orwell
    { isbn: "9780061120084" }, # To Kill a Mockingbird by Harper Lee
    { isbn: "9780743273565" }, # The Great Gatsby by F. Scott Fitzgerald
    { isbn: "9780141439518" }, # Pride and Prejudice by Jane Austen
    { isbn: "9780316769488" }, # The Catcher in the Rye by J.D. Salinger
    { isbn: "9780618640157" }, # The Lord of the Rings by J.R.R. Tolkien
    { isbn: "9780590353427" }, # Harry Potter and the Sorcerer's Stone by J.K. Rowling
    { isbn: "9780553577129" }, # The Diary of a Young Girl by Anne Frank
    { isbn: "9780547928227" }, # The Hobbit by J.R.R. Tolkien
    { isbn: "9780062315007" }  # The Alchemist by Paulo Coelho
  ]

  books.each do |book_attributes|
    book_details = BookApiService.fetch_book_details(book_attributes[:isbn])
    Book.create!(isbn: book_attributes[:isbn], title: book_details[:title], thumbnail: book_details[:thumbnail])
  end
end

# Seed data for bookshelves
def seed_bookshelves
  bookshelves = [
    {
      name: "Fantasy Collection",
      creator: "antonioturco@example.com",
      created_at: Time.now,
      updated_at: Time.now
    },
    {
      name: "Classic Literature",
      creator: "alessandrotemperini@example.com",
      created_at: Time.now,
      updated_at: Time.now
    },
    {
      name: "Modern Classics",
      creator: "alfredosegala@example.com",
      created_at: Time.now,
      updated_at: Time.now
    }
  ]

  bookshelves.each do |bookshelf_attributes|
    Bookshelf.create!(bookshelf_attributes)
  end
end

# Seed data for bookshelf_contains
def seed_bookshelf_contains
  bookshelf_contains = [
    {
      name: "Fantasy Collection",
      creator: "antonioturco@example.com",
      book: "9780618640157", # The Lord of the Rings
      created_at: Time.now,
      updated_at: Time.now
    },
    {
      name: "Fantasy Collection",
      creator: "antonioturco@example.com",
      book: "9780547928227", # The Hobbit by J.R.R. Tolkien
      created_at: Time.now,
      updated_at: Time.now
    },
    {
      name: "Classic Literature",
      creator: "alessandrotemperini@example.com",
      book: "9780451524935", # 1984 by George Orwell
      created_at: Time.now,
      updated_at: Time.now
    },
    {
      name: "Classic Literature",
      creator: "alessandrotemperini@example.com",
      book: "9780061120084", # To Kill a Mockingbird by Harper Lee
      created_at: Time.now,
      updated_at: Time.now
    },
    {
      name: "Modern Classics",
      creator: "alfredosegala@example.com",
      book: "9780743273565", # The Great Gatsby by F. Scott Fitzgerald
      created_at: Time.now,
      updated_at: Time.now
    },
    {
      name: "Modern Classics",
      creator: "alfredosegala@example.com",
      book: "9780316769488", # The Catcher in the Rye by J.D. Salinger
      created_at: Time.now,
      updated_at: Time.now
    }
  ]

  bookshelf_contains.each do |bookshelf_contains_attributes|
    BookshelfContain.create!(bookshelf_contains_attributes)
  end
end

# Main seeding function
def seed_database
  clear_existing_data
  seed_users
  seed_posts
  seed_books
  seed_bookshelves
  seed_bookshelf_contains
  puts "Seeded #{User.count} users, #{Post.count} posts, and #{Book.count} books."
end

# Run the seeding function
seed_database
