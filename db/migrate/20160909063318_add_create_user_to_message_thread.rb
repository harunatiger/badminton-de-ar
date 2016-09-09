class AddCreateUserToMessageThread < ActiveRecord::Migration
  def change
    change_table :message_threads do |t|
      t.references :create_user, index: true
    end
    add_foreign_key :message_threads, :users, column: 'create_user_id'
  end
end
