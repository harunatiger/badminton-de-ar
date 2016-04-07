class AddCategoryToListingImage < ActiveRecord::Migration
  def change
    add_column :listing_images, :category, :string, default: '', index: true
  end
end
