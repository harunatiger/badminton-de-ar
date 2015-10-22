class CreatePickupTags < ActiveRecord::Migration
  def change
    create_table :pickup_tags do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
