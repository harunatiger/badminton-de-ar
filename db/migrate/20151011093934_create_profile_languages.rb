class CreateProfileLanguages < ActiveRecord::Migration
  def change
    create_table :profile_languages do |t|
      t.references :profile, index: true
      t.references :language, index: true
      t.timestamps null: false
    end
    
    add_foreign_key :profile_languages, :profiles
    add_foreign_key :profile_languages, :languages
    
    ListingLanguage.all.each do |listing_language|
      ProfileLanguage.create :profile_id => listing_language.listing.user.profile.id, :language_id => listing_language.language_id
    end
  end
end
