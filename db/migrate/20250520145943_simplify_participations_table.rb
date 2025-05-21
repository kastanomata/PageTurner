class SimplifyParticipationsTable < ActiveRecord::Migration[8.0]
  def change
    change_table :participations do |t|
      t.remove :status, :string
      t.remove :registered_at, :datetime
      t.remove :attended_at, :datetime
    end
  end
end
