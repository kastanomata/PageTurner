include LoggingUtility
module InitializeUtility
  def initialize_user(user)
    # Create default bookshelves for the user
    read_bookshelf  = user.create_bookshelf(name: "#{user.nickname}'s Read Books", special: :true)
    liked_bookshelf = user.create_bookshelf(name: "#{user.nickname}'s Liked Books", special: :true)

    # Populate the special bookshelves with books from the user's posts
    user.posts.each do |post|
      read_bookshelf.add_book(post.book)
      liked_bookshelf.add_book(post.book) if rand < 1.0 / 3
    end
    # Create relationships and memberships
    random_follows = User.ids.sample(3)
    random_follows.each do |id|
      if user.id != id
        Relationship.create_or_find_by!(follower_id: user.id, followed_id: id)
      end
    end
    random_memberships = Club.ids.sample(1)
    random_memberships.each do |id|
      Membership.create_or_find_by!(follower_id: user.id, club_id: id)
    end
  end

  def initialize_bookclub(bookclub)
    # Create special bookshelves for each bookclub
    read_bookshelf  = bookclub.curator.create_bookshelf(name: "#{bookclub.name}'s Read Books", club: bookclub.id, special: :true)
    # Populate the special bookshelves with books from the bookclub's posts
    bookclub.posts.each do |post|
      read_bookshelf.add_book(post.book)
    end
  end

  def initialize_book(isbn)
    book_details = BookApiService.fetch_book_details(isbn)
    book_details[:isbn] = isbn
    return warning("Book not found: #{isbn}") unless book_details

    # Handle author
    author_details = BookApiService.fetch_author_details(book_details[:author_openlibrary_id])
    author = initialize_author(author_details)
    book_details[:author] = author

    # Set timestamps
    book_details[:created_at] = Time.now
    book_details[:updated_at] = Time.now

    # Create book
    book = Book.create_or_find_by!(book_details.except(:author_openlibrary_id, :tags))

    # Handle tags if present
    handle_tags(book, book_details[:tags]) if book_details[:tags].present?

    book
  rescue => e
    warn "Failed to seed book #{isbn}: #{e.message}"
    nil
  end

  def initialize_author(author_details)
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


  def initialize_tables
    # User initialization
    User.find_each { |user| initialize_user(user) }

    # Club initialization
    Club.find_each { |bookclub| initialize_bookclub(bookclub) }
  end

  private

  def handle_tags(book, tags_to_add)
    return unless tags_to_add.present?

    # Normalize and filter tags
    normalized_tags = tags_to_add.map { |t| t.downcase.strip }.uniq

    # Apply allowed tags filter if file exists
    if File.exist?("config/allowed_tags.txt")
      allowed_tags = File.readlines("config/allowed_tags.txt").map(&:strip).map(&:downcase)
      normalized_tags.select! { |t| allowed_tags.include?(t) }
    end

    return if normalized_tags.empty?

    # Find existing tags in one query
    existing_tags = Tag.where(name: normalized_tags).index_by(&:name)

    # Determine which tags need to be created
    tags_to_create = normalized_tags.reject { |t| existing_tags.key?(t) }

    # Bulk create missing tags (1 transaction)
    new_tags = []
    if tags_to_create.any?
      new_tags = Tag.insert_all(
        tags_to_create.map { |name| { name: name, created_at: Time.now, updated_at: Time.now } },
        returning: %w[id name]
      )
      existing_tags.merge!(new_tags.index_by { |t| t["name"] })
    end

    # Find all tag IDs for this book
    all_tag_ids = normalized_tags.map { |t| existing_tags[t]["id"] || existing_tags[t].id }

    # Find existing taggings to avoid duplicates
    existing_taggings = Tagging.where(book: book, tag_id: all_tag_ids).pluck(:tag_id).to_set

    # Prepare taggings to create (excluding existing ones)
    taggings_to_create = all_tag_ids.reject { |tag_id| existing_taggings.include?(tag_id) }
                                  .map { |tag_id| { book_id: book.id, tag_id: tag_id, created_at: Time.now } }

    # Bulk create taggings (1 transaction)
    Tagging.insert_all(taggings_to_create) if taggings_to_create.any?

    # Return the complete set of tags for this book
    normalized_tags
  end
end
