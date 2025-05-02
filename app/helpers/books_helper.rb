module BooksHelper
  def add_book_to_bookshelf_buttons(book)
    read_button = read_bookshelf_button(book)
    liked_button = liked_bookshelf_button(book)
    return unless read_button || liked_button

    content_tag :div, class: "bookshelf-buttons d-flex gap-2" do
      safe_join([ read_button, liked_button ].compact)
    end
  end

  def book_status_indicators(user, book)
    return unless user

    read_shelf, liked_shelf = get_special_bookshelves

    read = read_shelf&.books&.include?(book)
    liked = liked_shelf&.books&.include?(book)
    reading = user.reading_id == book.id

    content_tag :div, class: "book-indicators-container" do
      safe_join([
        (content_tag(:span, render_icon_image("reading"), class: "book-indicator reading-indicator", title: "Currently reading") if reading),
        (content_tag(:span, render_icon_image("read"), class: "book-indicator read-indicator", title: "Read") if read),
        (content_tag(:span, render_icon_image("liked"), class: "book-indicator liked-indicator", title: "Liked") if liked)
      ].compact)
    end
  end

  def set_book_as_reading(book)
    return unless Current.user

    if Current.user.reading.nil?
      button_text = "Start reading #{book.title}"
    else
      button_text = Current.user.reading == book ?
                   "Currently reading #{book.title}" :
                   "Switch to reading #{book.title}"
    end

    button_to button_text,
              update_reading_path(book_id: book.id),
              method: :patch,
              class: "reading-button",
              disabled: Current.user.reading == book
  end

  def book_image(book, size: "cover", image_id: nil)
    size_class, image_version = case size
    when "cover" then [ "book-image--cover", book&.cover ]
    when "thumbnail" then [ "book-image--thumbnail", book&.thumbnail ]
    when "poster" then [ "book-image--poster", book&.poster ]
    else [ "", book&.cover || book&.thumbnail || book&.poster ]
    end

    # Use the asset_path helper directly and ensure we have a string
    image_version = if image_version.blank?
      asset_path("bookart_not_found.png")
    else
      image_version.to_s
    end

    container_classes = [ "book-image-container", size_class ]
    container_classes << "book-image-container--not-found" if File.basename(image_version) == "bookart_not_found.png"

    content_tag(:div, class: container_classes.join(" "), id: image_id) do
      image_tag(image_version, class: "book-image", alt: "#{book&.title || 'Default'} #{size} image")
    end
  end

  def tag_color(tag_name)
    colors = [ "#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4", "#FFEEAD" ]
    colors[tag_name.downcase.hash % colors.size]
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
end
