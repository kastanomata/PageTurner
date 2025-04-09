class LikesController < ApplicationController
  before_action :set_like, only: %i[ show edit update destroy ]
  before_action :find_post
  before_action :find_like, only: %i[ destroy ]

  # GET /likes or /likes.json
  def index
    @likes = Like.all
  end

  # GET /likes/1 or /likes/1.json
  def show
  end

  # GET /likes/new
  def new
    @like = Like.new
  end

  # GET /likes/1/edit
  def edit
  end

  # POST /likes or /likes.json
  def create
    if already_liked?
      flash[:notice] = "You can't like more than once"
    else
      @post.likes.create(user_id: Current.user&.id)
    end
    redirect_to post_path(@post)
  end

  # PATCH/PUT /likes/1 or /likes/1.json
  def update
    respond_to do |format|
      if @like.update(like_params)
        format.html { redirect_to @like, notice: "Like was successfully updated." }
        format.json { render :show, status: :ok, location: @like }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /likes/1 or /likes/1.json
  def destroy
    if !(already_liked?)
      flash[:notice] = "Cannot unlike"
    else
      @like.destroy
    end
    redirect_to post_path(@post)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = Like.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def like_params
      params.expect(like: [ :post_id, :user_id ])
    end

    def find_post
      @post = Post.find(params[:post_id])
    end

    def find_like
      @like = @post.likes.find(params[:id])
   end

    def already_liked?
      Like.where(user_id: Current.user&.id, post_id:
      params[:post_id]).exists?
    end
end
