class CreateListingDetails < ActiveRecord::Migration
  def change
    create_table :listing_details do |t|
      t.references :listing, index: true
      t.string :zipcode, index: true
      t.string :location, default: '', index: true
      t.string :place, default: ''
      t.decimal :longitude, precision: 9, scale: 6, default: 0.0, index: true
      t.decimal :latitude, precision: 9, scale: 6, default: 0.0, index: true
      t.integer :price, default: 0, index: true
      t.integer :option_price, default: 0
      t.decimal :time_required, precision: 9, scale: 6, default: 0.0
      t.integer :max_num_of_people, default: 0
      t.integer :min_num_of_people, default: 0
      t.text :included, default: ''
      t.text :condition, default: ''
      t.text :refund_policy, default: ''
      t.text :in_case_of_rain, default: ''
      t.timestamps null: false
    end
    add_foreign_key :listing_details, :listings
  end
end
