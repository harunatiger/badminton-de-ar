class AddDescriptionToListingImages < ActiveRecord::Migration
  def change
    add_column :listing_images, :description, :text, after: :caption, default: ''
  end
end
