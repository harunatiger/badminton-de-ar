class CreateReservationExtraCosts < ActiveRecord::Migration
  def change
    create_table :reservation_extra_costs do |t|
      t.references :reservation, index: true, nil: false
      t.string :description, nil: false
      t.integer :price, nil: false, default: 0
      t.integer :for_each, nil: false
      t.timestamps null: false
    end
    add_foreign_key :reservation_extra_costs, :reservations
  end
end
