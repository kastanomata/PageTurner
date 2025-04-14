class AddAccountIdToAuthors < ActiveRecord::Migration[8.0]
  def change
    add_column :authors, :account_id, :string
  end
end
