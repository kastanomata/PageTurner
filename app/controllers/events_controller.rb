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
    @event.participations.build(user: @event.organizer)

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
      format.html { redirect_to root_path, status: :see_other, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def register
    @event = Event.find(params[:id])
    Current.user.attend(@event)
    redirect_to @event, notice: "You have successfully registered for this event."
  end

  def cancel_registration
    @event = Event.find(params[:id])
    Current.user.cancel_attendance(@event)
    redirect_to @event, notice: "Your registration has been cancelled."
  end

  # For organizers to mark attendance
  def mark_attendance
    @event = Event.find(params[:id])
    @user = User.find(params[:user_id])

    if @event.organizer == Current.user || Current.user.admin?
      @user.mark_attended(@event)
      redirect_to event_participants_path(@event), notice: "Attendance marked for #{@user.nickname}"
    else
      redirect_to @event, alert: "You don't have permission to do that."
    end
  end

  private
  def determine_organizer
    if Current.user.both_curator_and_author?
      params[:organizer_type].constantize.find(params[:organizer_id])
    else
      Current.user.club || Current.user.author_account
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
      :organizer_type,
      :start_time,
      :end_time,
      :book_id
    )
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
