module BookshelvesHelper
  def display_bookshelf_thumbnails(bookshelf)
    thumbnails = bookshelf.books

    content_tag(:div, class: "bookshelf-thumbnails-container") do
      content_tag(:div, class: "bookshelf-thumbnails-scroller") do
        safe_join(thumbnails.map do |book|
          if book.thumbnail
            link_to(book_image(book, size: "thumbnail"), book)
          end
        end)
      end
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

  def get_special_bookshelves
    return [] unless Current.user

    Current.user.bookshelves
            .includes(:books)  # Eager load books to prevent N+1 queries
            .where(bookclub: nil, special: true)
            .order(created_at: :asc)
            .then do |shelves|
              [
                shelves.find_by(name: "#{Current.user.nickname}'s Read Books"),
                shelves.find_by(name: "#{Current.user.nickname}'s Liked Books")
              ]
            end
  end

  private

  def render_bookshelf_card(bookshelf, user)
    render partial: "bookshelves/bookshelf_card",
           locals: {
             bookshelf: bookshelf,
             class_name: bookshelf.is_user_bound?(user) ? "special-bookshelf-card bookshelf-card" : "bookshelf-card",
             show_bookclub_info: bookshelf.bookclub.present?
           }
  end
end
