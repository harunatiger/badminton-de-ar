class CreateProfileIdentities < ActiveRecord::Migration
  def change
    create_table :profile_identities do |t|
      t.references :user, index: true, unique: true
      t.references :profile, index: true
      t.string :image, default: '', null: false
      t.string :caption, default: ''
      t.boolean :authorized, default: false, null: false

      t.timestamps null: false
    end
    add_foreign_key :profile_identities, :users
    add_foreign_key :profile_identities, :profiles
  end
end
