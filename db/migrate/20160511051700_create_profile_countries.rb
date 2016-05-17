class CreateProfileCountries < ActiveRecord::Migration
  def change
    create_table :profile_countries do |t|
      t.references :user, index: true, nil: false
      t.references :profile, index: true, nil: false
      t.string :country, default: '', nil: false, index: true
      t.timestamps null: false
    end
    add_foreign_key :profile_countries, :users
    add_foreign_key :profile_countries, :profiles
  end
end
