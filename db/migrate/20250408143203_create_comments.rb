class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.integer :post_id
      t.text :text
      t.string :author

      t.timestamps
    end
  end
end
