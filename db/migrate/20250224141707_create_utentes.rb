class CreateUtentes < ActiveRecord::Migration[8.0]
  def change
    create_table :utentes do |t|
      t.string :email
      t.string :nome

      t.timestamps
    end
  end
end
