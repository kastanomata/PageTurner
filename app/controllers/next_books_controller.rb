class NextBooksController < ApplicationController
  before_action :set_club
  before_action :authorize_curator

  def update
    if @club.update(next_book_id: params[:book_id])
      redirect_to @club, notice: "Next book was successfully updated."
    else
      redirect_to @club, alert: "Unable to update next book."
    end
  end

  private

  def set_club
    @club = Club.find(params[:club_id])
  end

  def authorize_curator
    redirect_to(@club, alert: "Only the curator can perform this action.") unless @club.curator == Current.user
  end
end
