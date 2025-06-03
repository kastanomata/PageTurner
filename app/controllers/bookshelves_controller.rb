class BookshelvesController < ApplicationController
  before_action :set_bookshelf, only: %i[ show edit update destroy ]
  allow_unauthenticated_access only: %i[index]

  # GET /bookshelves or /bookshelves.json
  def index
    @bookshelves = Bookshelf.all
  end

  # GET /bookshelves/1 or /bookshelves/1.json
  def show
    @bookshelf = Bookshelf.includes(bookshelf_contains: { book: :author }).find(params[:id])
    @timeline_entries = @bookshelf.bookshelf_contains
    .order(created_at: :asc)
    .includes(book: :author)
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
    creation_params = bookshelf_params.except(:book_isbns, :link_to_club)
    if bookshelf_params[:link_to_club] == "true"
      puts "Permitted!"
      creation_params[:bookclub] = Current.user&.club.id
    else
      puts "Boo!"
      creation_params[:bookclub] = nil
    end
    puts bookshelf_params.except(:book_isbns, :link_to_club).inspect
    @bookshelf = Current.user.bookshelves.build(creation_params)

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
    if bookshelf_params[:book_isbns].present?
      ActiveRecord::Base.transaction do
        bookshelf_params[:book_isbns].each do |isbn|
          book = Book.find_by(isbn: isbn)
          if book
            BookshelfContain.find_or_create_by(
              bookshelf_id: @bookshelf.id,
              book_id: book.id
            )
          end
        end
      end
    end

    respond_to do |format|
      if @bookshelf.update(bookshelf_params.except(:book_isbns))
        format.html { redirect_to @bookshelf, notice: "Bookshelf was successfully updated." }
        format.json { render :show, status: :ok, location: @bookshelf }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bookshelf.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.html { redirect_to @bookshelf, alert: "Error adding books: #{e.message}" }
      format.json { render json: { error: e.message }, status: :unprocessable_entity }
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
      params.require(:bookshelf).permit(:name, :book_id, :link_to_club, book_isbns: [])
    end
end
