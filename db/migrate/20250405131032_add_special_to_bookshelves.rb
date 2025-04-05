class AddSpecialToBookshelves < ActiveRecord::Migration[8.0]
  def change
    add_column :bookshelves, :special, :boolean
  end
end
