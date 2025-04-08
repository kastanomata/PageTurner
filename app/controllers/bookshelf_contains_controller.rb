class BookshelfContainsController < ApplicationController
  before_action :set_bookshelf_contain, only: [ :destroy ]
  # POST /bookshelf_contains
  def create
    # Logic for adding a book to the bookshelf
  end

  # DELETE /bookshelf_contains/:id
  def destroy
    @bookshelf_contain.destroy!
    redirect_back fallback_location: root_path, notice: "Book removed from shelf"
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: root_path, alert: "Record not found"
  end

  private

  def set_bookshelf_contain
    @bookshelf_contain = BookshelfContain.find_by!(
      name: params[:name],
      creator: params[:creator],
      book: params[:book]
    )
  end
end
