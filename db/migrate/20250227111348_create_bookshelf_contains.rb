class CreateBookshelfContains < ActiveRecord::Migration[8.0]
  def change
    create_table :bookshelf_contains do |t|
      t.string :name
      t.string :creator
      t.string :book

      t.timestamps
    end
  end
end
