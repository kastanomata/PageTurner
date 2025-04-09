class AddIsCuratorToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :is_curator, :boolean
  end
end
