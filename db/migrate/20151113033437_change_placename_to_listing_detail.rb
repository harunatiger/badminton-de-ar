class ChangePlacenameToListingDetail < ActiveRecord::Migration
  def up
    change_column :listing_details, :place_memo, :text, default: ''
  end

  def down
    change_column :listing_details, :place_memo, :string, default: ''
  end
end
