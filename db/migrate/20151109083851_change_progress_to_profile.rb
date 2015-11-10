class ChangeProgressToProfile < ActiveRecord::Migration
	def up
    change_column :profiles, :progress, :integer, null: false, default: 0
  end

  def down
    change_column :profiles, :progress, :integer
  end

  Profile.all.each do |p|
    Profile.set_percentage(p.user_id)
	end
end
