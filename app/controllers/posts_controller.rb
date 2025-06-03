include InitializeUtility
class PostsController < ApplicationController
  require_admin_access only: %i[ index ]
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
    @comment = @post.comments.build
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Current.user.posts.new(post_params.except(:isbn))
    # Store the referring URL for error cases
    @referrer = request.referer

    # Check if post is being created in the context of a club
    if params[:club_id].present?
      @post.club_id = params[:club_id]
    end

    begin
      isbn = params[:post][:isbn]
      @book = Book.find_by(isbn: isbn)
      if @book.nil?
        @book = InitializeUtility.initialize_book(isbn)
      end
      @post.book = @book

      if @post.save
        redirect_to @post, notice: "Post created!"
      else
        redirect_to @referrer, alert: @post.errors.full_messages.to_sentence
      end
    rescue => e
      redirect_to @referrer, alert: "Book lookup failed: #{e.message}"
    end
  end


  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to root_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :text, :isbn, :club_id)
    end
end
