class CreateUnscheduledTourGuides < ActiveRecord::Migration
  def change
    create_table :unscheduled_tour_guides do |t|
      t.references :unscheduled_tour, index: true, nil: false
      t.references :pair_guide, index: true, nil: false
      t.timestamps null: false
    end
    add_foreign_key :unscheduled_tour_guides, :unscheduled_tours
    add_foreign_key :unscheduled_tour_guides, :users, column: 'pair_guide_id'
  end
end
