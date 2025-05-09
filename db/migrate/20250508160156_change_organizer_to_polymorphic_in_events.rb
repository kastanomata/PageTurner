class ChangeOrganizerToPolymorphicInEvents < ActiveRecord::Migration[8.0]
  def change
    remove_column :events, :organizer_id
    remove_column :events, :club_id

    add_reference :events, :organizer, polymorphic: true, null: false
  end
end
