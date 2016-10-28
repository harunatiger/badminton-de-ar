class AddSoftDestroyedAtToSpot < ActiveRecord::Migration
  def change
    add_column :spots, :soft_destroyed_at, :datetime, index: true
  end
end
