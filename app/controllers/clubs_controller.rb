class ClubsController < ApplicationController
  allow_unauthenticated_access only: %i[ index show members ]
  before_action :set_club, only: %i[ show edit update destroy ]

  # GET /clubs or /clubs.json
  def index
    @clubs = Club.all
  end

  # GET /clubs/1 or /clubs/1.json
  def show
    @post = Post.new
    @post.club = @club
    @club = Club.includes(book_suggestions: [ :book, :user ]).find(params[:id])
    @club = Club.includes(polls: { poll_options: [ :book, :votes ] }).find(params[:id])
    @books = Book.all
  end

  # GET /clubs/new
  def new
    @club = Club.new
  end

  # GET /clubs/1/edit
  def edit
  end

  # POST /clubs or /clubs.json
  def create
    if Current.user.club.present?
      redirect_to club_path Current.user.club, notice: "You already are a Curator!"
      return
    end
    @club = Club.new(club_params)
    @club.curator = Current.user
    respond_to do |format|
      if @club.save
        format.html { redirect_to @club, notice: "Club was successfully created." }
        format.json { render :show, status: :created, location: @club }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clubs/1 or /clubs/1.json
  def update
    respond_to do |format|
      if @club.update(club_params)
        format.html { redirect_to @club, notice: "Club was successfully updated." }
        format.json { render :show, status: :ok, location: @club }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  def members
    @title = "Members"
    @club  = Club.find(params[:id])
    @members = @club.members.paginate(page: params[:page])
    render "memberships/show_members"
  end

  # DELETE /clubs/1 or /clubs/1.json
  def destroy
    @club.destroy!

    respond_to do |format|
      format.html { redirect_to clubs_path, status: :see_other, notice: "Club was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def delete_post
    @club = Club.find(params[:id])
    if Current.user == @club.curator
      @post = @club.posts.find_by(id: params[:post_id])
      if @post
        @post.update(club: nil)
        redirect_to @club, notice: "Post successfully removed from the club."
      else
        redirect_to @club, alert: "Post not found."
      end
    else
      redirect_to @club, alert: "You are not authorized to perform this action."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to clubs_path, alert: "Club not found."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_club
      @club = Club.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def club_params
      params.require(:club).permit(:name, :description)
    end
end
