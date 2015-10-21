class AddThumbnailToProfileImage < ActiveRecord::Migration
  def change
    add_column :profile_images, :cover_image, :string, default: ''
  end
end
