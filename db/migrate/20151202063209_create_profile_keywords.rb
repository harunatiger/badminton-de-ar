class CreateProfileKeywords < ActiveRecord::Migration
  def change
    create_table :profile_keywords do |t|
      t.references :user, index: true, unique: true
      t.references :profile, index: true
      t.timestamps null: false
    end
    add_foreign_key :profile_keywords, :users
    add_foreign_key :profile_keywords, :profiles
  end
end
