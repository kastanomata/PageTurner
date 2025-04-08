class RenameAuthorToAuthorIdInComments < ActiveRecord::Migration[8.0]
  def change
    rename_column :comments, :author, :author_id
  end
end
