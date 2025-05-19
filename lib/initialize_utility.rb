include LoggingUtility
module InitializeUtility
  def initialize_user(user)
    # Load sample comments
    comments_path = Rails.root.join("db", "seeds", "comments.json")
    comments_data = JSON.parse(File.read(comments_path))

    # Create default bookshelves
    read_bookshelf = user.create_bookshelf(name: "#{user.nickname}'s Read Books", special: true)
    liked_bookshelf = user.create_bookshelf(name: "#{user.nickname}'s Liked Books", special: true)

    # Create relationships and memberships
    random_follows = User.where.not(id: user.id).sample(3)
    random_follows.each do |followed_user|
      user.follow(followed_user)

      # Like and comment on some of their posts
      followed_user.posts.each do |post|
        # 75% chance to like the post
        if rand < 0.75
          user.likes.create(post: post)
        end

        # 50% chance to comment on the post
        if rand < 0.5
          comment_content = comments_data.sample
          post.comments.create(
            author_id: user.id,
            text: comment_content,
            created_at: rand(1..30).days.ago # Randomize comment timing
          )
        end
      end
    end

    # Join random clubs
    Club.all.sample(1).each do |club|
      Membership.create_or_find_by!(follower_id: user.id, club_id: club.id)

      # Like and comment on some club posts
      club.posts.sample(3).each do |post|
        if rand < 0.5 # 50% chance to interact with club posts
          user.likes.create(post: post) if rand < 0.75
          if rand < 0.5
            post.comments.create(
              author_id: user.id,
              text: comments_data.sample,
              created_at: rand(1..30).days.ago
            )
          end
        end
      end
    end

    # Populate bookshelves with books from posts
    user.posts.each do |post|
      read_bookshelf.bookshelf_contains.create(book: post.book)
      liked_bookshelf.bookshelf_contains.create(book: post.book) if rand < 1.0/3
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

    author = if book_details[:author_openlibrary_id].present?
              Author.find_by(openlibrary_id: book_details[:author_openlibrary_id]) ||
              initialize_author(book_details[:author_openlibrary_id])
    end

    unless author
      return warn "Could not find or create author for book #{isbn}"
    end

    book_details[:author] = author
    book_details[:created_at] = Time.now
    book_details[:updated_at] = Time.now

    # Create book with author association
    book = Book.create_or_find_by!(isbn: isbn) do |b|
      b.assign_attributes(book_details.except(:author_openlibrary_id, :tags))
    end

    handle_tags(book, book_details[:tags]) if book_details[:tags].present?
    book
  rescue => e
    warn "Failed to seed book #{isbn}: #{e.message}"
    nil
  end

  def initialize_author(author_openlibrary_id)
    return nil unless author_openlibrary_id.present?

    existing_author = Author.find_by(openlibrary_id: author_openlibrary_id)
    return existing_author if existing_author

    author_details = BookApiService.fetch_author_details(author_openlibrary_id)
    unless author_details
      return nil
    end

    begin
      attributes = {
        openlibrary_id: author_openlibrary_id,
        name: author_details[:name] || "Unknown Author"
      }

      attributes[:bio] = author_details[:bio].is_a?(Hash) ?
                        author_details[:bio].values.max_by(&:length) :
                        author_details[:bio] if author_details[:bio]

      attributes[:photo] = author_details[:photos]&.first if author_details[:photos]
      attributes[:born_on] = author_details[:birth_date] if author_details[:birth_date]
      attributes[:died_on] = author_details[:death_date] if author_details[:death_date]

      author = Author.create!(attributes)
      author
    rescue ActiveRecord::RecordInvalid => e
      begin
        Author.create!(
          openlibrary_id: author_openlibrary_id,
          name: author_details[:name] || "Unknown Author"
        )
      rescue => e
        Rails.logger.error "Fallback author creation failed: #{e.message}"
        nil
      end
    rescue => e
      Rails.logger.error "Author creation error: #{e.message}"
      nil
    end
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
