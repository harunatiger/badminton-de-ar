class AddAddminClosedAt < ActiveRecord::Migration
  def change
    add_column :listings, :admin_closed_at, :datetime
    add_column :spots, :admin_closed_at, :datetime
  end
end
