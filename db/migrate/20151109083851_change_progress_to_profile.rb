class ChangeProgressToProfile < ActiveRecord::Migration
	def up
    change_column :profiles, :progress, :integer, null: false, default: 0
  end

  def down
    change_column :profiles, :progress, :integer
  end
end
