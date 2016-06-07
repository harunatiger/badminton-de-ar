class CreateProfilePickups < ActiveRecord::Migration
  def change
    create_table :profile_pickups do |t|
      t.references :profile, index: true
      t.references :pickup, index: true
      t.timestamps null: false
    end
    add_foreign_key :profile_pickups, :profiles
    add_foreign_key :profile_pickups, :pickups
  end
end
