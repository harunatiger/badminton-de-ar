class AddSoftDestroyedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :soft_destroyed_at, :datetime, index:true
    add_column :users, :email_before_closed, :string, default: ''
  end
end
