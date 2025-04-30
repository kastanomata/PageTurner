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
        post_details = {}
        post_details[:title] = post_attributes[:title]
        post_details[:text] = post_attributes[:text]
        post_details[:author_id] = User.find_by(email_address: post_attributes[:author_email]).id
        post_details[:book_id] = Book.find_by(isbn: post_attributes[:book_isbn]).id
        post_details[:club_id] = Club.find_by(name: post_attributes[:club_name]).id if post_attributes[:club_name]
        post_details[:club_id] ||= nil
        post_details[:created_at] = Time.now
        post_details[:updated_at] = Time.now
        Post.create!(post_details)
      end
    end

    def seed_author(author_details)
      return nil unless author_details[:openlibrary_id].present?

      begin
        new_author = Author.find_or_create_by!(openlibrary_id: author_details[:openlibrary_id]) do |author|
          puts "Creating new author #{author_details[:name]}"
          author.name = author_details[:name] || "Unknown Author"
          author.bio = author_details[:bio] if author_details.key?(:bio)
          author.born_on = author_details[:birth_date] if author_details.key?(:birth_date)
          author.died_on = author_details[:death_date] if author_details.key?(:death_date)
          author.remote_avatar_url = author_details[:portrait] if author_details[:portrait].present?
        end
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error "Author seeding failed: #{e.record.errors.full_messages.join(', ')}"
        nil
      rescue StandardError => e
        Rails.logger.error "Unexpected error seeding author: #{e.message}"
        nil
      end
      new_author
    end

    # Seed data for books
    def seed_books
      books = load_json_file(Rails.root.join("db", "seeds", "books.json"))
      books.each do |book_attributes|
        # puts "Creating book #{book_attributes[:_codename]}"
        book_details = BookApiService.fetch_book_details(book_attributes[:isbn])
        book_attributes.update(book_details)
        author_details = BookApiService.fetch_author_details(book_attributes[:author_openlibrary_id])
        if book_details
          author = seed_author(author_details)
          book_attributes[:author] = author
          book_attributes[:created_at] = Time.now
          book_attributes[:updated_at] = Time.now
          book = Book.create!(book_attributes.except(:_codename, :author_openlibrary_id, :tags))
          if book_details[:tags].present?
            book_details[:tags].each do |tag_name|
              tag = Tag.find_or_create_by!(name: tag_name.downcase.strip)
              Tagging.find_or_create_by!(book: book, tag: tag)
            end
          end
        else
          warning "Book not found: #{book_attributes[:_codename]}"
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

    private

    def random_time_between(start_time = 1.year.ago, end_time = Time.now)
      Time.at(rand(start_time.to_f..end_time.to_f))
    end
end
