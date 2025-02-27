class AddTitleToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :title, :string
  end
end
