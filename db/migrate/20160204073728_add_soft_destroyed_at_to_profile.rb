class AddSoftDestroyedAtToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :soft_destroyed_at, :datetime, index:true
  end
end
