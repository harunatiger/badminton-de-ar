class CreateReservationOptions < ActiveRecord::Migration
  def change
    create_table :reservation_options do |t|
      t.references :reservation, index: true
      t.references :option, index: true
      t.integer :price, default: 0, index: true
      t.timestamps null: false
    end
    add_foreign_key :reservation_options, :reservations
    add_foreign_key :reservation_options, :options
  end
end
