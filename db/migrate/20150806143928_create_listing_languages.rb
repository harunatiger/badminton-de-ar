class CreateListingLanguages < ActiveRecord::Migration
  def change
    create_table :listing_languages do |t|
      t.references :listing, index: true
      t.references :language, index: true

      t.timestamps null: false
    end
    
    add_foreign_key :listing_languages, :listings
    add_foreign_key :listing_languages, :languages
  end
end
