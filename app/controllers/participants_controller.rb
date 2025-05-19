class ParticipantsController < ApplicationController
  before_action :set_event

  def index
    @participations = @event.participations.includes(:user)
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end
