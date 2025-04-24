class AddReadingToUser < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :reading, foreign_key: { to_table: :books }
  end
end
