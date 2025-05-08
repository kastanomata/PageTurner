class CreateCuratorIcons < ActiveRecord::Migration[8.0]
  def change
    create_table :curator_icons do |t|
      t.string :name

      t.timestamps
    end
  end
end
