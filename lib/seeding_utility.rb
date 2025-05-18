include LoggingUtility
include InitializeUtility
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

  # Seed data for books
  def seed_books
    books = load_json_file(Rails.root.join("db", "seeds", "books.json"))
    books.each do |book_attributes|
      initialize_book(book_attributes[:isbn])
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

  def seed_events
    events = load_json_file(Rails.root.join("db", "seeds", "events.json"))

    events.each do |event_attributes|
      # Find or initialize the organizer (user)
      if event_attributes[:organizer_type] == "Club"
        curator_id = User.find_by!(email_address: event_attributes[:organizer_email]).id
        organizer = Club.find_by!(curator_id: curator_id)
      elsif event_attributes[:organizer_type] == "Author"
        author_id = User.find_by!(email_address: event_attributes[:organizer_email]).id
        organizer = Author.find_by!(account_id: author_id)
      end
      unless organizer_id
        puts "Skipping event '#{event_attributes[:title]}' - Club with curator.email_address #{event_attributes[:organizer_email]} not found"
      end
      puts "#{organizer} - #{event_attributes[:organizer_type]} with curator.email_address #{event_attributes[:organizer_email]} found"

      # Initialize the event with direct attributes
      event = Event.new(
        title: event_attributes[:title],
        description: event_attributes[:description],
        start_time: Time.current + 1.week, # Default to one week from now
        end_time: Time.current + 1.week + 2.hours, # Default to 2 hour duration
        organizer: organizer
      )

      # Associate book if ISBN is provided
      if event_attributes[:book_isbn].present?
        event.book = Book.find_by(isbn: event_attributes[:book_isbn])
      end

      event.save!
    end
  end

  private

  def random_time_between(start_time = 1.year.ago, end_time = Time.now)
    Time.at(rand(start_time.to_f..end_time.to_f))
  end
end
