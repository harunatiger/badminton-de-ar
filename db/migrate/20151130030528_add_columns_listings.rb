class AddColumnsListings < ActiveRecord::Migration
  def change
    add_column :listings, :overview, :text, default: ''
    add_column :listings, :notes, :text, default: ''
    add_column :listings, :recommend1, :string, default: ''
    add_column :listings, :recommend2, :string, default: ''
    add_column :listings, :recommend3, :string, default: ''
    add_column :listing_details, :included_other, :text, default: ''
  end
end
