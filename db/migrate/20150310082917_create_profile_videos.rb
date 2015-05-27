class CreateProfileVideos < ActiveRecord::Migration
  def change
    create_table :profile_videos do |t|
      t.references :user, index: true, unique: true
      t.references :profile, index: true
      t.string :video, default: '', null: false
      t.string :caption, default: ''

      t.timestamps null: false
    end
    add_foreign_key :profile_videos, :users
    add_foreign_key :profile_videos, :profiles
  end
end
