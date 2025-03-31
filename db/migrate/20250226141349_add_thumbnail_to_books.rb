class AddThumbnailToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :thumbnail, :string
  end
end
