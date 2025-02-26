class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :nickname
      t.string :description
      t.string :birthday

      t.timestamps
    end
  end
end
