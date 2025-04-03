class CreateClubs < ActiveRecord::Migration[8.0]
  def change
    create_table :clubs do |t|
      t.string :name, null: false
      t.string :description
      t.string :curator, null: false
      t.timestamps
    end
  end
end
