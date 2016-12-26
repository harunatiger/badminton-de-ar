class AddBecomeGuideAt < ActiveRecord::Migration
  def change
    add_column :users, :became_main_guide_at, :datetime
    add_column :users, :became_support_guide_at, :datetime
  end
end
