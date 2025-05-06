class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description

      # References
      t.references :book, null: true, foreign_key: true
      t.references :organizer, null: false, foreign_key: { to_table: :users }
      t.references :club, null: true, foreign_key: true

      # Event timing
      t.datetime :start_time, null: false
      t.datetime :end_time

      t.timestamps
    end
  end
end
