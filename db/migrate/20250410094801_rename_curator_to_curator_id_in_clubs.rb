class RenameCuratorToCuratorIdInClubs < ActiveRecord::Migration[8.0]
  def change
    rename_column :clubs, :curator, :curator_id
  end
end
