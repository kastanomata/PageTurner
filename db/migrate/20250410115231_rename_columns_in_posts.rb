class RenameColumnsInPosts < ActiveRecord::Migration[8.0]
  def change
    rename_column :posts, :creator, :author_id
    rename_column :posts, :club, :club_id
    rename_column :posts, :book, :book_id
  end
end
