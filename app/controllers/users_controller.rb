include SessionsHelper
include InitializeUtility

class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create show ]
  before_action -> { require_authentication("admin") }, only: %i[ index ]
  before_action :set_user, only: %i[ show edit update destroy ]
  skip_before_action :check_nickname, only: [ :edit, :update ]
  before_action :logged_in_user, only: [ :index, :edit, :update, :destroy, :following, :followers ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    # Normalize and check email address
    @user.email_address = @user.email_address.strip.downcase
    if @user.admin.nil?
      @user.admin = false
      puts @user.nickname, "is not an admin"
    end

    respond_to do |format|
      if @user.save
        start_new_session_for @user
        # Create default bookshelves for the user
        initialize_user(@user)
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :update, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/puts /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        # Update special bookshelves to match the new nickname
        special_bookshelves = Bookshelf.where(
          creator: @user.email_address,
          bookclub: nil,
          special: true
        )
        special_bookshelves.each do |bookshelf|
          log_star("Updating bookshelf name for user #{@user.nickname}")
          if bookshelf.name.include?("Read Books")
            bookshelf.update(name: "#{@user.nickname}'s Read Books")
          elsif bookshelf.name.include?("Liked Books")
            bookshelf.update(name: "#{@user.nickname}'s Liked Books")
          end
        end
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def make_admin
    @user = User.find(params[:id])
    @user.update(admin: :true)  # Ensure your User model has a :role attribute
    redirect_to users_path, notice: "User promoted to admin"
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to root_path, status: :see_other, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def admin?
    authenticated? and self.admin == true
  end

  def owner?
    authenticated? and self.id == Current.session&.id
  end

  def require_admin
    render json: { message: "admin only, not authorized" }, status: :unauthorized unless current_user.admin?
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  def search
    if params[:query].present?
      @users = User.where("nickname LIKE ?", "%#{params[:query]}%")
    else
      @users = User.all
    end
  end

  def remove_avatar
    @user = User.find(params[:id])
    @user.avatar.purge # Rimuove il file associato
    redirect_to edit_user_path(@user), notice: "Foto profilo rimossa con successo."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.expect(user: [ :email_address, :password, :nickname, :description, :birthday, :avatar, :admin ])
    end
end
