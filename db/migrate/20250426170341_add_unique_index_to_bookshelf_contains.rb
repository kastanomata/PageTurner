class AddUniqueIndexToBookshelfContains < ActiveRecord::Migration[8.0]
  def change
    add_index :bookshelf_contains, [ :bookshelf_id, :book_id ], unique: true, name: 'index_bookshelf_contains_on_bookshelf_and_book'
  end
end
