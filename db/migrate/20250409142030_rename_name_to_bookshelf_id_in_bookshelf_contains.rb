class RenameNameToBookshelfIdInBookshelfContains < ActiveRecord::Migration[8.0]
  def change
    rename_column :bookshelf_contains, :name, :bookshelf_id
    rename_column :bookshelf_contains, :creator, :creator_id
  end
end
