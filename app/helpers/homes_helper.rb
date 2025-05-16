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

    # Filter bookshelves with at least one book
    user_bookshelves = bookshelves.select { |b| b.special? && b.bookclub.nil? && b.bookshelf_contains.any? }
    club_bookshelves = bookshelves.select { |b| b.special? && b.bookclub.present? && b.bookshelf_contains.any? }
    other_bookshelves = bookshelves.reject { |b| b.special? || b.bookclub.present? }
                                  .select { |b| b.bookshelf_contains.any? }

    content_parts = []

    # Only show "Your Bookshelves" header if there are user bookshelves
    if user_bookshelves.any? || other_bookshelves.any?
      content_parts << content_tag(:h2, "Your Bookshelves")
    end

    # User's special bookshelves with books
    content_parts += user_bookshelves.map do |bookshelf|
      render_bookshelf_card(bookshelf, user)
    end

    # Other bookshelves with books
    content_parts += other_bookshelves.map do |bookshelf|
      render_bookshelf_card(bookshelf, user)
    end

    # Club bookshelves section (only if there are club bookshelves with books)
    if club_bookshelves.any?
      club_content = [
        content_tag(:h2, "Club Bookshelves"),
        *club_bookshelves.map { |bookshelf| render_bookshelf_card(bookshelf, user) }
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
