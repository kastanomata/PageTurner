class AddForeignKeyToUsersCuratorIcon < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :curator_icon_id, :integer
    add_foreign_key :users, :curator_icons, column: :curator_icon_id
  end
end
