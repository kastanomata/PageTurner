module BookshelvesHelper
  def display_bookshelf_thumbnails(bookshelf)
    thumbnails = bookshelf.books

    content_tag(:div, class: "bookshelf-thumbnails-container") do
      content_tag(:div, class: "bookshelf-thumbnails-scroller") do
        safe_join(thumbnails.map do |book|
          if book.thumbnail
            link_to(image_tag(book.thumbnail, alt: book.title), book)
          end
        end)
      end
    end
  end

  def render_user_bookshelves(user)
    bookshelves = user.bookshelves
    user_bookshelves = bookshelves.select { |b| b.special? && b.bookclub.nil? }
    club_bookshelves = bookshelves.select { |b| b.special? && b.bookclub.present? }
    other_bookshelves = bookshelves - user_bookshelves - club_bookshelves

    content_parts = [ content_tag(:h2, "Your Bookshelves") ]

    # User's special bookshelves
    content_parts += user_bookshelves.map do |bookshelf|
      render_bookshelf_card(bookshelf, user)
    end

    # Other bookshelves
    content_parts += other_bookshelves.map do |bookshelf|
      render_bookshelf_card(bookshelf, user)
    end

    # Club bookshelves section
    if club_bookshelves.any?
      club_content = [
        content_tag(:h2, "Club Bookshelves"),
        *club_bookshelves.map { |bookshelf| render_bookshelf_card(bookshelf, user) }
      ]
      content_parts += club_content
    end

    content_tag :div, class: "bookshelves-container" do
      safe_join(content_parts)
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
             class_name: bookshelf.is_user_bound?(user) ? "special-bookshelf bookshelf" : "bookshelf",
             show_bookclub_info: bookshelf.bookclub.present?
           }
  end
end
