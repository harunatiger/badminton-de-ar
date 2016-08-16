class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :from_user, index: true, null: false
      t.references :to_user, index: true
      t.references :listing, index: true
      t.datetime :read_at
      t.string :type, index: true, null: false
      t.datetime :soft_destroyed_at, index: true
      t.timestamps null: false
    end
    add_foreign_key :favorites, :users, column: 'to_user_id'
    add_foreign_key :favorites, :users, column: 'from_user_id'
    add_foreign_key :favorites, :listings, column: 'listing_id'
  end
end
