class SyncCuratorStatusFromClubs < ActiveRecord::Migration[8.0]
  def up
    # Set is_curator=true for users who are curators of any club
    User.where(id: Club.select(:curator_id)).update_all(is_curator: true)

    # Set is_curator=false for users who aren't curators of any club
    User.where.not(id: Club.select(:curator_id)).update_all(is_curator: false)
  end
end
