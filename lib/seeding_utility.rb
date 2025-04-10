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
        # log_star("Book details: #{book_details.inspect}")
        book_attributes[:created_at] = Time.now
        book_attributes[:updated_at] = Time.now
        if book_details
          Book.create!(isbn: book_attributes[:isbn], title: book_details[:title], thumbnail: book_details[:thumbnail])
        else
          # log_star("Book not found: #{book_attributes[:_codename]}")
        end
      end
    end

    # Seed data for bookshelves and bookshelf_contains
    def seed_bookshelves
      bookshelves = load_json_file(Rails.root.join("db", "seeds", "bookshelves.json"))
      bookshelves.each do |bookshelf_attributes|
        bookshelf_attributes[:created_at] = Time.now
        bookshelf_attributes[:updated_at] = Time.now
        bookshelf_attributes[:creator_id] = User.find_by(nickname: bookshelf_attributes[:creator_nickname]).id
        # # log_star "Bookshelf creator: #{bookshelf_attributes[:creator_nickname]}, ID: #{bookshelf_attributes[:creator_id]}"
        bookshelf = Bookshelf.create!(bookshelf_attributes.except(:books_list, :creator_nickname))
        # # log_star "Bookshelf created: #{bookshelf.inspect}"
        bookshelf_attributes[:books_list].each do |book|
          book = Book.find_by(isbn: book[:isbn])
          # # log_star "Book found: #{book.inspect}"
          if book
            bookshelf.add_book(book)
          else
            # log_star("Book not found for Bookshelf: #{book[:isbn]}")
          end
        end
      end
    end

    # Seed data for clubs
    def seed_clubs
      clubs = load_json_file(Rails.root.join("db", "seeds", "clubs.json"))
      clubs.each do |bookclub_attributes|
        bookclub_attributes[:curator_id] = User.find_by(email_address: bookclub_attributes[:curator_email]).id
        bookclub_attributes[:created_at] = Time.now
        bookclub_attributes[:updated_at] = Time.now
        Club.create!(bookclub_attributes.except(:curator_email))
      end
    end
end
