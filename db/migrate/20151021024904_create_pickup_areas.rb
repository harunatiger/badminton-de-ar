class CreatePickupAreas < ActiveRecord::Migration
  def change
    create_table :pickup_areas do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
