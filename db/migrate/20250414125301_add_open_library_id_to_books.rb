class AddOpenLibraryIdToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :openlibrary_id, :string
  end
end
