class AddAuthorRequestToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :author_request, :string
  end
end
