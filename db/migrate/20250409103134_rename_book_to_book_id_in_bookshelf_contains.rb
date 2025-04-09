class RenameBookToBookIdInBookshelfContains < ActiveRecord::Migration[8.0]
  def change
    rename_column :bookshelf_contains, :book, :book_id
  end
end
