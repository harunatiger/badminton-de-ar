class AddAuthorizedUserStatusToListing < ActiveRecord::Migration
  def change
    add_column :listings, :authorized_user_status, :integer, default: 0
  end
end
