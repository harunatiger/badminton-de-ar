class AddPlanningForYouToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :planning_for_you, :boolean
  end
end
