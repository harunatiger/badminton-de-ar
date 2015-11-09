class AddColumnToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :progress, :integer, :default => 0
  end
end
