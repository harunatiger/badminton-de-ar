class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.references :user, index: true
      t.integer :review_count, default: 0
      t.float :ave_total, default: 0.0
      t.float :ave_accuracy, default: 0.0
      t.float :ave_communication, default: 0.0
      t.float :ave_cleanliness, default: 0.0
      t.float :ave_location, default: 0.0
      t.float :ave_check_in, default: 0.0
      t.float :ave_cost_performance, default: 0.0
      t.boolean :open, default: false
      t.string :zipcode, index: true
      t.string :location, default: '', index: true
      t.decimal :longitude, precision: 9, scale: 6, default: 0.0, index: true
      t.decimal :latitude, precision: 9, scale: 6, default: 0.0, index: true
      t.boolean :delivery_flg, default: false
      t.integer :price, default: 0, index: true
      t.text :description, default: ''
      t.string :title, default: '', index: true
      t.integer :capacity, default: 0, index: true
      t.text :direction, default: ''
      t.string :cover_image, default: ''
      t.string :cover_image_caption, default: ''

      t.timestamps null: false
    end
    add_foreign_key :listings, :users
  end
end
