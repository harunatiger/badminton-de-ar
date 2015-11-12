class AddPlacenameToListingDetail < ActiveRecord::Migration
  def change
    add_column :listing_details, :place_memo, :string, default: ''
  end
end
