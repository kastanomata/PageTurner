class AddInfoToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :nickname, :string
    add_column :users, :description, :string
    add_column :users, :birthday, :string
  end
end
