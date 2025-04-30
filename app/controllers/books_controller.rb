class BooksController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]
  before_action :set_book, only: %i[ show edit update destroy ]

  # GET /books or /books.json
  def index
    @books = if params[:isbn].present?
              Book.where("isbn LIKE ?", "#{params[:isbn]}%")
    else
              Book.all
    end

    respond_to do |format|
      format.html  # Regular HTML response
      format.json { render json: @books.to_json(only: [ :id, :isbn, :title, :author, :cover, :thumbnail, :poster ]) }
    end
  end

  # GET /books/1 or /books/1.json
  def show
    @book = Book.find_by(id: params[:id])
    @popular_tags = Tag.popular(5)
    unless @book
      api_data = BookApiService.fetch_by_isbn(params[:id])
      if api_data[:error]
        flash[:alert] = "Book not found."
        redirect_to books_path
      else
        @book = Book.create!(isbn: params[:id], title: api_data[:title], cover_url: api_data[:cover_url])
      end
    end
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)
    if @book.isbn.present?
      book_details = BookApiService.fetch_book_details(@book.isbn)
      @book.title = book_details[:title] if book_details[:title].present?
      @book.thumbnail = book_details[:thumbnail] if book_details[:thumbnail].present?
      @book.cover = book_details[:cover] if book_details[:cover].present?
      @book.poster = book_details[:poster] if book_details[:poster].present?
      @book.process_open_library_tags(book_details[:tags]) if book_details[:tags]
    end

    if @book.save
      redirect_to @book, notice: "Book was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy!

    respond_to do |format|
      format.html { redirect_to books_path, status: :see_other, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :isbn)
    end
end
