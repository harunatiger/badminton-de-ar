class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.integer :order_number, null: false
      t.string :image, null: false
      t.string :image_sp, null: false
      t.timestamps null: false
    end
  end
end
