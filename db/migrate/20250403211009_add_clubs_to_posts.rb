class AddClubsToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :club, :string
    add_column :posts, :curator, :string
  end
end
