class AddBioAndPhotoToAuthors < ActiveRecord::Migration[8.0]
  def change
    add_column :authors, :bio, :text, null: true
    add_column :authors, :photo, :string, null: true
  end
end
