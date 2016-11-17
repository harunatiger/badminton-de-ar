class AddcolumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :admin_closed_at, :datetime
    add_column :users, :remarks, :text
    add_column :users, :star_guide, :boolean, default: false
  end
end
