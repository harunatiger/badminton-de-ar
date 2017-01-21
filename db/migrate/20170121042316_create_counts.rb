class CreateCounts < ActiveRecord::Migration
  def change
    create_table :counts do |t|
      t.integer :player_id, nil: false
      t.integer :count, nil: false, default: 0
      t.timestamps null: false
    end
  end
end
