class BookSuggestionsController < ApplicationController
  before_action :set_club
  before_action :ensure_member, only: [ :create ]

  def create
    @book_suggestion = @club.book_suggestions.new(book_suggestion_params)
    @book_suggestion.user = Current.user

    if @book_suggestion.save
      redirect_to @club, notice: "Book suggestion added!"
    else
      redirect_to @club, alert: "Error adding suggestion"
    end
  end

  def destroy
    @book_suggestion = @club.book_suggestions.find(params[:id])
    @book_suggestion.destroy
    redirect_to @club, notice: "Suggestion removed"
  end

  private

  def set_club
    @club = Club.find(params[:club_id])
  end

  def ensure_member
    return if @club.members.include?(Current.user)

    redirect_to @club, alert: "You must be a club member to suggest books"
  end

  def book_suggestion_params
    params.require(:book_suggestion).permit(:book_id)
  end
end
