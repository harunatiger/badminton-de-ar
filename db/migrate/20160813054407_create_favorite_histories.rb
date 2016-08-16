class CreateFavoriteHistories < ActiveRecord::Migration
  def change
    create_table :favorite_histories do |t|
      t.references :from_user, index: true, null: false
      t.references :to_user, index: true
      t.references :listing, index: true
      t.datetime :read_at
      t.string :type, index: true, null: false
      t.timestamps null: false
    end
    add_foreign_key :favorite_histories, :users, column: 'to_user_id'
    add_foreign_key :favorite_histories, :users, column: 'from_user_id'
    add_foreign_key :favorite_histories, :listings, column: 'listing_id'
  end
end
