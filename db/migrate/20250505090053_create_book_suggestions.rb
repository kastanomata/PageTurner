class CreateBookSuggestions < ActiveRecord::Migration[8.0]
  def change
    create_table :book_suggestions do |t|
      t.references :club, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
