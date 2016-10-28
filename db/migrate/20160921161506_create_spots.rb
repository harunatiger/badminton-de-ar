class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.references :user, index: true, null: false
      t.string :title, null: false
      t.string :one_word, default: ''
      t.references :pickup, index: true
      t.string :location, default: ''
      t.decimal :longitude,  precision: 9, scale: 6
      t.decimal :latitude,  precision: 9, scale: 6
      t.timestamps null: false
    end
    add_foreign_key :spots, :users
    add_foreign_key :spots, :pickups, column: 'pickup_id'
  end
end
