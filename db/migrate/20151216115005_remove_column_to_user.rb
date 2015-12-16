class RemoveColumnToUser < ActiveRecord::Migration
  def change
    remove_column :users, :facebook_oauth
  end
end
