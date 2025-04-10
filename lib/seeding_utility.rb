include LoggingUtility
module SeedingUtility
    # helper function to load JSON files
    def load_json_file(file_path)
      file_content = File.read(file_path)
      JSON.parse(file_content, symbolize_names: true)
    rescue Errno::ENOENT
      puts "File not found: #{file_path}"
      []
    rescue JSON::ParserError => e
      puts "Failed to parse JSON file: #{file_path}. Error: #{e.message}"
      []
    end

    # Seed data for users
    def seed_users
      users = load_json_file(Rails.root.join("db", "seeds", "users.json"))
      users.each do |user_attributes|
        user_attributes[:admin] ||= false
        User.create!(user_attributes)
      end
    end

    # Seed data for posts
    def seed_posts
      posts = load_json_file(Rails.root.join("db", "seeds", "posts.json"))
      posts.each do |post_attributes|
        post_attributes[:creator] = post_attributes[:creator].downcase
        Post.create!(post_attributes)
      end
    end

    # Seed data for books
    def seed_books
      books = load_json_file(Rails.root.join("db", "seeds", "books.json"))
      books.each do |book_attributes|
        book_details = BookApiService.fetch_book_details(book_attributes[:isbn])
        unless book_details
          log_star("Book not found: #{book_attributes[:_codename]}")
          next
        end
        Book.create!(isbn: book_attributes[:isbn], title: book_details[:title], thumbnail: book_details[:thumbnail])
      end
    end

    # Seed data for bookshelves
    def seed_bookshelves
      bookshelves = load_json_file(Rails.root.join("db", "seeds", "bookshelves.json"))
      bookshelves.each do |bookshelf_attributes|
        Bookshelf.create!(bookshelf_attributes)
      end
    end

    # Seed data for bookshelf_contains
    def seed_bookshelf_contains
      bookshelf_contains = load_json_file(Rails.root.join("db", "seeds", "bookshelf_contains.json"))
      expanded_bookshelf_contains = bookshelf_contains[:bookshelf_contains].flat_map do |entry|
        entry[:books].map do |book|
          {
            name: entry[:name],
            creator: entry[:creator],
            book: book[:isbn]
          }
        end
      end
      expanded_bookshelf_contains.each do |bookshelf_contains_attributes|
        BookshelfContain.create!(bookshelf_contains_attributes)
      end
    end

    # Seed data for bookclubs
    def seed_bookclubs
      bookclubs = load_json_file(Rails.root.join("db", "seeds", "clubs.json"))
      bookclubs.each do |bookclub_attributes|
        Club.create!(bookclub_attributes)
      end
    end
end
