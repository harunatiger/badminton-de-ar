class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :code, index: true, null: false, unique: true
      t.integer :discount, index: true
      t.string :type, index: true
      t.timestamps null: false
    end
  end
end
