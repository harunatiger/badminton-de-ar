class AddRegisterDetailToListing < ActiveRecord::Migration
  def change
    add_column :listing_details, :register_detail, :boolean, default: false
  end
end
