class AddOmniauthColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uid,      :string, null: false, default: ''
    add_column :users, :provider, :string, null: false, default: ''
    add_column :users, :username, :string
    add_index :users, [:uid, :provider], unique: true
    add_index :users, :username, unique: true
  end
end
