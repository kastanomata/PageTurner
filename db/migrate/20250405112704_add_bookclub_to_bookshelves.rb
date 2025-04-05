class AddBookclubToBookshelves < ActiveRecord::Migration[8.0]
  def change
    add_column :bookshelves, :bookclub, :string
  end
end
