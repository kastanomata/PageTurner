module BooksHelper
  def add_book_to_bookshelf_buttons(book)
    read_button = read_bookshelf_button(book)
    liked_button = liked_bookshelf_button(book)
    return unless read_button || liked_button

    content_tag :div, class: "bookshelf-buttons d-flex gap-2" do
      safe_join([ read_button, liked_button ].compact)
    end
  end

  private

  def read_bookshelf_button(book)
    bookshelf = get_special_bookshelves[0]
    return unless bookshelf

    if bookshelf.books.include?(book)
      remove_button(bookshelf, book, "Read", "danger")
    else
      add_button(bookshelf, book, "Read", "success")
    end
  end

  def liked_bookshelf_button(book)
    bookshelf = get_special_bookshelves[1]
    return unless bookshelf

    if bookshelf.books.include?(book)
      remove_button(bookshelf, book, "Liked", "danger")
    else
      add_button(bookshelf, book, "Liked", "primary")
    end
  end

  def add_button(bookshelf, book, type, style)
    button_to "Add to #{type}",
              add_book_bookshelf_path(bookshelf, book_id: book.id),
              method: :post,
              class: "btn btn-outline-#{style}",
              data: { confirm: "Add '#{book.title}' to your #{type} books?" }
  end

  def remove_button(bookshelf, book, type, style)
    button_to "Remove from #{type}",
              remove_book_bookshelf_path(bookshelf, book_id: book.id),
              method: :delete,
              class: "btn btn-#{style}",
              data: { confirm: "Remove '#{book.title}' from your #{type} books?" }
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
end
