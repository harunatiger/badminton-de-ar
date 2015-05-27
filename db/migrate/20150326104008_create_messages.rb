class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :message_thread, index: true, null: false
      t.integer :from_user_id, index: true, null: false
      t.integer :to_user_id, index: true, null: false
      t.text :content, default: '', null: false
      t.boolean :read, default: false
      t.datetime :read_at
      t.integer :listing_id, default: 0, index: true, null: false
      t.integer :reservation_id, default: 0, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :messages, :message_threads
    add_foreign_key :messages, :users, column: 'from_user_id'
    add_foreign_key :messages, :users, column: 'to_user_id'
  end
end
