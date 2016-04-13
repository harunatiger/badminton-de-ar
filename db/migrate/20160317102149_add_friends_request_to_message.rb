class AddFriendsRequestToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :friends_request, :boolean, default: false
  end
end
