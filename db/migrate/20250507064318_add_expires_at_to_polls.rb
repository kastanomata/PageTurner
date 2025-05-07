class AddExpiresAtToPolls < ActiveRecord::Migration[8.0]
  def change
    add_column :polls, :expires_at, :datetime
  end
end
