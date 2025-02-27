class CreateBookshelves < ActiveRecord::Migration[8.0]
  def change
    create_table :bookshelves do |t|
      t.string :name
      t.string :creator

      t.timestamps
    end
  end
end
