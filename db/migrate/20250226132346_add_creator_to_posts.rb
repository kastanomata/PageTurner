class AddCreatorToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :creator, :string
  end
end
