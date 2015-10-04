class CreateProfileBanks < ActiveRecord::Migration
  def change
    create_table :profile_banks do |t|
      t.references :user, index: true, unique: true
      t.references :profile, index: true
      t.string :name
      t.string :branch_name
      t.integer :account_type
      t.string :user_name
      t.string :number
      t.timestamps null: false
    end
    add_foreign_key :profile_banks, :users
    add_foreign_key :profile_banks, :profiles
  end
end
