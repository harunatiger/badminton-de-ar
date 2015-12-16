class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_oauth, :integer, default: 0
  end
end
