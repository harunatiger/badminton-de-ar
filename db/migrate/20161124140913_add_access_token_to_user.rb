class AddAccessTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :uuid, :uuid, index: true
    add_column :users, :access_token, :string, index: true
    add_column :users, :access_token_expires_at, :string
  end
end
