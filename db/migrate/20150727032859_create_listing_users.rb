class CreateListingUsers < ActiveRecord::Migration
  def change
    create_table :listing_users do |t|
      t.references :listing, index: true, null: false
      t.references :host, index: true, null: false
      t.timestamps null: false
    end    
    add_foreign_key :listing_users, :users, column: 'host_id'
    add_foreign_key :listing_users, :listings
  end
end
