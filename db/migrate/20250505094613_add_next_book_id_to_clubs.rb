class AddNextBookIdToClubs < ActiveRecord::Migration[8.0]
  def change
    add_column :clubs, :next_book_id, :integer
  end
end
