class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true, null: false
      t.string :first_name, default: ''
      t.string :last_name, default: ''
      t.date :birthday
      t.integer :gender
      t.string :phone, default: ''
      t.boolean :phone_verification, default: false
      t.string :zipcode, default: ''
      t.string :location, default: ''
      t.text :self_introduction, default: ''
      t.string :school, default: ''
      t.string :work, default: ''
      t.string :timezone, default: ''
      t.integer :listing_count, default: 0
      t.integer :wishlist_count, default: 0
      t.integer :bookmark_count, default: 0
      t.integer :reviewed_count, default: 0
      t.integer :reservation_count, default: 0
      t.float :ave_total, default: 0.0
      t.float :ave_accuracy, default: 0.0
      t.float :ave_communication, default: 0.0
      t.float :ave_cleanliness, default: 0.0
      t.float :ave_location, default: 0.0
      t.float :ave_check_in, default: 0.0
      t.float :ave_cost_performance, default: 0.0

      t.timestamps null: false
    end
    add_foreign_key :profiles, :users
  end
end
