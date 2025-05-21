class ParticipationsController < ApplicationController
  before_action :set_event, only: [ :create, :destroy, :index ]  # Added :index here

  def index
    @participations = @event.participations.includes(:user)  # Eager load users to avoid N+1 queries
    respond_to do |format|
      format.html  # renders index.html.erb
      format.json { render json: @participations }
    end
  end

  def create
    @participation = current_user.attend(@event)
    respond_to do |format|
      format.html { redirect_to @event }
      format.js   # creates create.js.erb for AJAX
    end
  end

  def destroy
    current_user.cancel_attendance(@event)
    respond_to do |format|
      format.html { redirect_to @event }
      format.js   # creates destroy.js.erb for AJAX
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end
