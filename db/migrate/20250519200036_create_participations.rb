class CreateParticipations < ActiveRecord::Migration[6.1]
  def change
    create_table :participations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.string :status, default: 'registered' # or 'attended', 'cancelled'
      t.datetime :registered_at
      t.datetime :attended_at

      t.timestamps
    end

    add_index :participations, [:user_id, :event_id], unique: true
  end
end