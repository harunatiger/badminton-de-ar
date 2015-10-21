class CreateProfileCategories < ActiveRecord::Migration
  def change
    create_table :profile_categories do |t|
      t.references :profile, index: true
      t.references :category, index: true
      t.timestamps null: false
    end
    
    add_foreign_key :profile_categories, :profiles
    add_foreign_key :profile_categories, :categories
    
    ListingCategory.all.each do |listing_category|
      ProfileCategory.create :profile_id => listing_category.listing.user.profile.id, :category_id => listing_category.category_id
    end
  end
end
