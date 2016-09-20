class CreateSpotImages < ActiveRecord::Migration
  def change
    create_table :spot_images do |t|
      t.references :spot, null: false, index: true
      t.string :image, null: false
      t.timestamps null: false
    end
    add_foreign_key :spot_images, :spots, column: 'spot_id'
  end
end
