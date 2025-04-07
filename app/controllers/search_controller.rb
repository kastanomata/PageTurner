class SearchController < ApplicationController
  def index
    if params[:query].present?
      @users = User.where("nickname LIKE ?", "%#{params[:query]}%")
      @books = Book.where("title LIKE ?", "%#{params[:query]}%")
      @clubs = Club.where("name LIKE ?", "%#{params[:query]}%")
    else
      @users = []
      @books = []
      @clubs = []
    end
  end
end
