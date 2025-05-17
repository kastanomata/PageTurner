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

  def display_bookshelf_posts(bookshelf)
    # Get all book IDs in this bookshelf
    book_ids = bookshelf.books.pluck(:id)

    # Find posts where:
    # 1. The author is the bookshelf creator
    # 2. The post is about a book in this bookshelf
    posts = Post.where(author_id: bookshelf.creator_id, book_id: book_ids)
              .order(created_at: :desc)

    # Render the posts or return empty message
    if posts.any?
      render partial: "posts/post_card", collection: posts, as: :post
    else
      content_tag(:p, "No posts yet about books in this shelf", class: "no-posts")
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
