module HomesHelper
  def render_homepage_based_on_authentication
    if authenticated?
      render "homepage"
    else
      render "guestpage"
    end
  end

  def render_user_bookshelves(user)
    # Preload bookshelf_contains to avoid N+1 queries
    bookshelves = user.bookshelves.includes(:bookshelf_contains)

    # Categorize bookshelves
    user_bookshelves = bookshelves.select { |b| b.special? && b.bookclub.nil? }
    club_bookshelves = bookshelves.select { |b| b.special? && b.bookclub.present? }
    other_bookshelves = bookshelves.reject { |b| b.special? || b.bookclub.present? }

    # Split each category into those with books and those without
    user_with_books, user_empty = user_bookshelves.partition { |b| b.bookshelf_contains.any? }
    club_with_books, club_empty = club_bookshelves.partition { |b| b.bookshelf_contains.any? }
    other_with_books, other_empty = other_bookshelves.partition { |b| b.bookshelf_contains.any? }

    content_parts = []

    # Only show "Your Bookshelves" header if there are user bookshelves
    if user_with_books.any? || other_with_books.any? || user_empty.any? || other_empty.any?
      content_parts << content_tag(:h2, "Your Bookshelves")
    end

    # User's special bookshelves with books
    content_parts += user_with_books.map { |bookshelf| render_bookshelf_card(bookshelf, user) }
    # Other bookshelves with books
    content_parts += other_with_books.map { |bookshelf| render_bookshelf_card(bookshelf, user) }
    # User's special bookshelves without books
    content_parts += user_empty.map { |bookshelf| render_bookshelf_card(bookshelf, user) }
    # Other bookshelves without books
    content_parts += other_empty.map { |bookshelf| render_bookshelf_card(bookshelf, user) }

    # Club bookshelves section (only if there are club bookshelves)
    if club_with_books.any? || club_empty.any?
      club_content = [
        content_tag(:h2, "Club Bookshelves"),
        *club_with_books.map { |bookshelf| render_bookshelf_card(bookshelf, user) },
        *club_empty.map { |bookshelf| render_bookshelf_card(bookshelf, user) }
      ]
      content_parts += club_content
    end

    # Only render container if there are any bookshelves to show
    if content_parts.any?
      content_tag :div, class: "bookshelf-cards-container" do
        safe_join(content_parts)
      end
    else
      content_tag :div, class: "no-bookshelves-message" do
        "You haven't added any books to your bookshelves yet."
      end
    end
  end

  def render_homepage_posts(user)
    # Posts from users the current user follows
    following_posts = Post.where(author_id: user.following_ids)
                        .order(created_at: :desc)

    # Posts from clubs the user is a member of
    memberships_posts = Post.where(club_id: user.partecipates.ids)
                          .order(created_at: :desc)

    # Combine both post collections, remove duplicates, and sort by creation date
    posts = (following_posts.to_a | memberships_posts.to_a)
            .sort_by(&:created_at)
            .reverse

    content = []

    if posts.any?
      list_content = render(partial: "posts/post_card", collection: posts.uniq, as: :post)
      content << content_tag(:ul, list_content, class: "homepage-content")
    else
      content << content_tag(:p, "Nessun post disponibile.")
    end

    # Wrap everything in a homepage-content container
    content_tag(:div, safe_join(content), class: "homepage-content")
  end
end
