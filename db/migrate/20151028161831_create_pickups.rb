class CreatePickups < ActiveRecord::Migration
  def change
    create_table :pickups do |t|
      t.string :name, default: '', index: true
      t.string :cover_image, default: ''
      t.integer :selected_listing
      t.string :type, index: true
      t.integer :order_number
      t.timestamps null: false
    end
  end
end
