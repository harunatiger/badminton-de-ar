class CreateMessageThreadUsers < ActiveRecord::Migration
  def change
    create_table :message_thread_users do |t|
      t.references :message_thread, null: false, index: true
      t.references :user, null: false, index: true

      t.timestamps null: false
    end

    add_index :message_thread_users, [:message_thread_id, :user_id], unique: true
    add_foreign_key :message_thread_users, :message_threads
    add_foreign_key :message_thread_users, :users
  end
end
