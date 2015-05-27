class CreateConfections < ActiveRecord::Migration
  def change
    create_table :confections do |t|
      t.references :listing, index: true
      t.string :name, null: false
      t.string :url, default: ''
      t.string :image, default: ''

      t.timestamps null: false
    end
    add_index :confections, [:listing_id, :name], unique: true
    add_foreign_key :confections, :listings
  end
end
