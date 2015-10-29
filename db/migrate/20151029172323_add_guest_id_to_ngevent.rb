class AddGuestIdToNgevent < ActiveRecord::Migration
  def change
    add_column :ngevents, :guest_id, :integer, after: :user_id, index: true
  end
end
