class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.string :session_id, index: true
      t.integer :user_id, index: true
      t.string :method
      t.string :page
      t.string :referer
      t.string :country
      t.string :devise
      t.datetime :accessed_at
      t.timestamps null: false
    end
  end
end
