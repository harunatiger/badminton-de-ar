class CreatePickupCategories < ActiveRecord::Migration
  def change
    create_table :pickup_categories do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
