class CreateFavoriteUsers < ActiveRecord::Migration
  def change
    create_table :favorite_users do |t|
      t.integer :from_user_id, index: true, null: false
      t.integer :to_user_id, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :favorite_users, :users, column: 'from_user_id'
    add_foreign_key :favorite_users, :users, column: 'to_user_id'
  end
end
