class RemoveClubFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :club, :string
  end
end
