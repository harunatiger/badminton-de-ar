class CreateProfileLanguages < ActiveRecord::Migration
  def change
    create_table :profile_languages do |t|
      t.references :user, index: true, unique: true
      t.references :profile, index: true
      t.references :language, index: true
      t.timestamps null: false
    end
    
    add_foreign_key :profile_languages, :users
    add_foreign_key :profile_languages, :profiles
    add_foreign_key :profile_languages, :languages
    
    ListingLanguage.all.each do |listing_language|
      ProfileLanguage.create :user_id => listing_language.listing.user.id, :profile_id => listing_language.listing.user.profile.id, :language_id => listing_language.language_id
    end
  end
end
