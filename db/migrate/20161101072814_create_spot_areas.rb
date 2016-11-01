class CreateSpotAreas < ActiveRecord::Migration
  def change
    create_table :spot_areas do |t|
      t.references :spot, index: true, nil: false
      t.references :pickup, index: true, nil: false
      t.timestamps null: false
    end
    add_foreign_key :spot_areas, :spots
    add_foreign_key :spot_areas, :pickups
  end
end
