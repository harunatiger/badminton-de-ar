class AddRegisterDetailToListing < ActiveRecord::Migration
  def change
    add_column :listing_details, :register_detail, :boolean, default: false
    Listing.all.each do |l|
      if l.listing_detail.present?
        ld = ListingDetail.where(listing_id: l.id).first
        ld.update!(register_detail: true)
      end
    end
  end
end
