class AddBackgroundThemeToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :background_theme, :string, default: :default
  end
end
