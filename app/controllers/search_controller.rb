class SearchController < ApplicationController
  def index
    if params[:query].present?
      @authors = Author.where("name LIKE :q OR bio LIKE :q", q: "%#{params[:query]}%")
      @books = Book.where("title LIKE :q OR isbn = :isbn", q: "%#{params[:query]}%", isbn: params[:query])
      @bookshelves = Bookshelf.where("name LIKE :q", q: "%#{params[:query]}%")
      @clubs = Club.where("name LIKE :q OR description LIKE :q", q: "%#{params[:query]}%")
      @events = Event.where("title LIKE :q OR description LIKE :q", q: "%#{params[:query]}%")
      @posts = Post.where("title LIKE :q OR text = :isbn", q: "%#{params[:query]}%", isbn: params[:query])
      @tags = Tag.where("name LIKE :q", q: "%#{params[:query]}%")
      @users = User.where("nickname LIKE :q", q: "%#{params[:query]}%")
    else
      # Set all instance variables to empty arrays if no query is present
      instance_variables = %i[
        authors books bookshelves clubs events posts tags users
      ]
      instance_variables.each { |var| instance_variable_set("@#{var}", []) }
    end

    # Compute result as dictionary of all elements
    @result = {
      authors: @authors,
      books: @books,
      bookshelves: @bookshelves,
      clubs: @clubs,
      events: @events,
      posts: @posts,
      tags: @tags,
      users: @users
    }
  end
end
