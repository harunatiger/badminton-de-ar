class CreateListingUsers < ActiveRecord::Migration
  def change
    create_table :listing_users do |t|
      t.references :listing, index: true, nil: false
      t.references :user, index: true, nil: false
      t.integer :user_status
      t.text :request_message
      t.timestamps null: false
    end
    add_foreign_key :listing_users, :listings
    add_foreign_key :listing_users, :users
  end
end
