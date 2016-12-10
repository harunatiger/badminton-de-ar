class AddTitle2ToListing < ActiveRecord::Migration
  def change
    add_column :listings, :title_2, :string, default: ''
  end
end
