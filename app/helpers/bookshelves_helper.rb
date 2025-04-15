module BookshelvesHelper
  def render_user_bookshelves(user)
    content_tag :div, class: "bookshelves-container" do
      bookshelves = user.bookshelves
      user_bookshelves = bookshelves.select { |b| b.special? && b.bookclub == nil }
      club_bookshelves = bookshelves.select { |b| b.special? && !(b.bookclub == nil) }
      other_bookshelves = bookshelves - user_bookshelves - club_bookshelves

      ordered_bookshelves = user_bookshelves + club_bookshelves + other_bookshelves
      safe_join(
        ordered_bookshelves.map do |bookshelf|
          render partial: "bookshelves/bookshelf_card",
                 locals: {
                   bookshelf: bookshelf,
                   class_name: bookshelf.is_user_bound?(user) ? "special-bookshelf bookshelf" : "bookshelf",
                   show_bookclub_info: bookshelf.bookclub.present?
                 }
        end
      )
    end
  end
end
