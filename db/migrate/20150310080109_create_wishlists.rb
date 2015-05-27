class CreateWishlists < ActiveRecord::Migration
  def change
    create_table :wishlists do |t|
      t.references :user, index: true
      t.string :name
      t.string :range

      t.timestamps null: false
    end
    add_foreign_key :wishlists, :users
    add_index :wishlists, [:user_id, :name], unique: true
  end
end
