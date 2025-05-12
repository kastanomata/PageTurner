class AddBackgroundThemeToUsers < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:users, :background_theme)
      add_column :users, :background_theme, :string, default: :default
    end
  end
end
