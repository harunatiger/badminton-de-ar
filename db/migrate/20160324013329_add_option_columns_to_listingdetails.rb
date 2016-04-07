class AddOptionColumnsToListingdetails < ActiveRecord::Migration
  def change
    add_column :listing_details, :bicycle_option, :boolean, default: false
    add_column :listing_details, :bicycle_rental, :integer, default: 0
    add_column :listing_details, :other_option, :boolean, default: false
    add_column :listing_details, :other_cost, :integer, default: 0

    ListingDetail.all.each do |ld|
      price_both = ld.price_for_both_guides
      price_space = ld.space_rental
      m_price = price_both + price_space
      ld.update!(other_option: true, other_cost: m_price) if m_price != 0
    end
  end
end
