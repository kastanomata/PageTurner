class AddBookToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :book, :string
  end
end
