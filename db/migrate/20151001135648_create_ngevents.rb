class CreateNgevents < ActiveRecord::Migration
  def change
    create_table :ngevents do |t|
      t.references :user, index: true
    	t.references :reservation, index: true
      t.integer :listing_id
      t.date :start, null: false
    	t.date :end, null: false
      t.date :end_bk
    	t.integer :mode, default: 0, null: false, index:true
    	t.string :color, default: 'gray'
      t.integer :active, default: 1
      t.timestamps null: false
    end
  end
end
