class CreateReports < ActiveRecord::Migration[8.0]
  def change
    create_table :reports do |t|
      t.string :reporter_id
      t.string :reported_id
      t.string :reported_type

      t.timestamps
    end
  end
end
