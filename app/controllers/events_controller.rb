class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :load_organizer_options, only: [ :new, :edit ]

  # GET /events or /events.json
  def index
    @events = Event.all
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    @event.book = Book.new
  end
  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)
    @event.organizer = determine_organizer

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        load_organizer_options
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    @event.organizer = determine_organizer

    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        load_organizer_options
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy!

    respond_to do |format|
      format.html { redirect_to events_path, status: :see_other, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  def determine_organizer
    if Current.user.both_curator_and_author?
      params[:organizer_type].constantize.find(params[:organizer_id])
    else
      Current.user.club || Current.user.author
    end
  end

  def load_organizer_options
    @organizer_options = []
    @organizer_options << Current.user.club_organizer if Current.user.is_curator?
    @organizer_options << Current.user.author_organizer if Current.user.is_author?
  end

  def event_params
    params.require(:event).permit(
      :title,
      :description,
      :start_time,
      :end_time,
      :book_id
    )
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
