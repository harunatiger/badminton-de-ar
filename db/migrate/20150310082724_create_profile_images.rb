class CreateProfileImages < ActiveRecord::Migration
  def change
    create_table :profile_images do |t|
      t.references :user, index: true, unique: true
      t.references :profile, index: true
      t.string :image, default: '', null: false
      t.string :caption, default: ''

      t.timestamps null: false
    end
    add_foreign_key :profile_images, :users
    add_foreign_key :profile_images, :profiles
  end
end
