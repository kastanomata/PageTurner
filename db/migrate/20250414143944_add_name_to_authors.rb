class AddNameToAuthors < ActiveRecord::Migration[8.0]
  def change
    add_column :authors, :name, :string
  end
end
