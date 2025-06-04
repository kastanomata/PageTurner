class ReadingGoalsController < ApplicationController
  before_action :set_club
  before_action :require_curator, except: [ :show ]

  def new
    @reading_goal = @club.reading_goals.new
  end

  def show
    @reading_goal = @club.reading_goals.find(params[:id])
  end

  def create
    @reading_goal = @club.reading_goals.new(reading_goal_params)

    if @reading_goal.start_date < Date.today || @reading_goal.end_date < Date.today
      flash.now[:alert] = "Start date and end date must be today or later."
      render :new
    elsif @reading_goal.start_date > @reading_goal.end_date
      flash.now[:alert] = "Start date cannot be after the end date."
      render :new
    elsif @reading_goal.save
      redirect_to @club, notice: "Reading goal was successfully created."
    else
      render :new
    end
  end

  def edit
    @reading_goal = @club.reading_goals.find(params[:id])
  end

  def update
    @reading_goal = @club.reading_goals.find(params[:id])
    if @reading_goal.update(reading_goal_params)
      redirect_to [ @club, @reading_goal ], notice: "Goal updated"
    else
      render :edit
    end
  end

  def destroy
    @reading_goal = @club.reading_goals.find(params[:id])
    @reading_goal.destroy
    redirect_to @club, notice: "Goal deleted"
  end

  private

  def set_club
    @club = Club.find(params[:club_id])
  end

  def reading_goal_params
    params.require(:reading_goal).permit(:book_id, :start_date, :end_date)
  end

  def require_curator
    unless Current.user == @club.curator
      redirect_to @club, alert: "Only the club curator can perform this action."
    end
  end
end
