class PollsController < ApplicationController
  before_action :find_club
  before_action :authorize_curator!, only: [ :new, :create ]

  def new
    @poll = @club.polls.new
    @poll.poll_options.build
    @books = Book.all
  end

  def create
    if @club.polls.exists?
      redirect_to club_path(@club), alert: "There is already an active poll for this club"
      return
    end

    @poll = @club.polls.new(poll_params)

    if @poll.save
      redirect_to club_path(@club), notice: "Poll created successfully"
    else
      @books = Book.all
      render :new
    end
  end

  def destroy
    @poll = Poll.find(params[:id])
    authorize_curator!
    if @poll.destroy
      redirect_to club_path(@club), notice: "Poll deleted successfully"
    else
      redirect_to club_path(@club), alert: "Failed to delete poll"
    end
  end

  private

  def find_club
    @club = Club.find(params[:club_id])
  end

  def authorize_curator!
    return if @club.curator == Current.user

    redirect_to club_path(@club), alert: "Only club curators can create polls"
  end

  def poll_params
    params.require(:poll).permit(
      :title,
      :description,
      :expires_at,
      poll_options_attributes: [ :id, :book_id, :_destroy ]
    )
  end
end
