class RenameAgainNameToBookshelfIdInBookshelfContains < ActiveRecord::Migration[8.0]
  def change
    rename_column :bookshelf_contains, :name, :bookshelf_id
  end
end
