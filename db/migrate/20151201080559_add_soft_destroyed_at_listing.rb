class AddSoftDestroyedAtListing < ActiveRecord::Migration
  def change
    add_column :listings, :soft_destroyed_at, :datetime, index:true
  end
end
