class CreateMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :memberships do |t|
      t.integer :follower_id
      t.integer :club_id

      t.timestamps
    end
    add_index :memberships, :follower_id
    add_index :memberships, :club_id
    add_index :memberships, [ :follower_id, :club_id ], unique: true
  end
end
