class AddReadAtToFavorite < ActiveRecord::Migration
  def change
    add_column :favorite_users, :read_at, :datetime
    add_column :favorite_listings, :read_at, :datetime
  end
end
