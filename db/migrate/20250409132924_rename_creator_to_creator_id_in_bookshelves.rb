class RenameCreatorToCreatorIdInBookshelves < ActiveRecord::Migration[8.0]
  def change
    rename_column :bookshelves, :creator, :creator_id
  end
end
