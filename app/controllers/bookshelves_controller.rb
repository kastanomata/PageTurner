class BookshelvesController < ApplicationController
  before_action :set_bookshelf, only: %i[ show edit update destroy ]
  allow_unauthenticated_access only: %i[index show]

  # GET /bookshelves or /bookshelves.json
  def index
    @bookshelves = Bookshelf.all
  end

  # GET /bookshelves/1 or /bookshelves/1.json
  def show
  end

  # GET /bookshelves/new
  def new
    @bookshelf = Bookshelf.new
  end

  # GET /bookshelves/1/edit
  def edit
  end

  # POST /bookshelves or /bookshelves.json
  def create
    @bookshelf = Current.user.bookshelves.build(bookshelf_params.except(:book_isbns))

    respond_to do |format|
      if @bookshelf.save
        # Process ISBNs after save
        process_isbns(@bookshelf)

        format.html { redirect_to @bookshelf, notice: "Bookshelf was successfully created." }
        format.json { render :show, status: :created, location: @bookshelf }
      else
        format.html { render :new }
        format.json { render json: @bookshelf.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookshelves/1 or /bookshelves/1.json
  def update
    respond_to do |format|
      if @bookshelf.update(bookshelf_params)
        format.html { redirect_to @bookshelf, notice: "Bookshelf was successfully updated." }
        format.json { render :show, status: :ok, location: @bookshelf }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bookshelf.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_book
    @bookshelf = Bookshelf.find(params[:id])
    @book = Book.find(params[:book_id])
    @bookshelf.books << @book
    redirect_back fallback_location: root_path
  end

  def remove_book
    @bookshelf = Bookshelf.find(params[:id])
    @book = Book.find(params[:book_id])
    @bookshelf.books.delete(@book)
    redirect_back fallback_location: root_path
  end

  # DELETE /bookshelves/1 or /bookshelves/1.json
  def destroy
    @bookshelf.destroy!

    respond_to do |format|
      format.html { redirect_to bookshelves_path, status: :see_other, notice: "Bookshelf was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookshelf
      @bookshelf = Bookshelf.find(params.expect(:id))
    end

    def process_isbns(bookshelf)
      return unless params[:bookshelf][:book_isbns]

      params[:bookshelf][:book_isbns].reject(&:blank?).each do |isbn|
        book = Book.find_by(isbn: isbn)
        next unless book

        BookshelfContain.find_or_create_by(
          bookshelf_id: bookshelf.id,
          book_id: book.id
        )
      end
    end

    def bookshelf_params
      params.require(:bookshelf).permit(:name, :book_id, book_isbns: [])
    end
end
