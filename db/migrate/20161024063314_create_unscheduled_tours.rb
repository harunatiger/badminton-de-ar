class CreateUnscheduledTours < ActiveRecord::Migration
  def change
    create_table :unscheduled_tours do |t|
      t.references :listing, index: true, nil: false
      t.references :guide, index: true, nil: false
      t.string :uuid, nil: false
      t.timestamps null: false
    end
    add_foreign_key :unscheduled_tours, :listings
    add_foreign_key :unscheduled_tours, :users, column: 'guide_id'
  end
end
