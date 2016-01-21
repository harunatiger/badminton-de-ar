class ChangeColumnProfileImage < ActiveRecord::Migration
  def change
    add_column :profile_images, :order_num, :integer, index: true
    add_column :profile_images, :cover_flg, :boolean, default: false, index: true
    ProfileImage.all.each do |profile_image|
      if profile_image.cover_image.present?
        if profile_image.image.present?
          cover_image = ProfileImage.new(image_blank_ok: true, user_id: profile_image.user_id, profile_id: profile_image.profile_id, image: profile_image.cover_image.file, cover_flg: true)
          cover_image.save!
          profile_image.update!(order_num: 1, cover_flg: false)
        else
          profile_image.update!(image_blank_ok: true, image: profile_image.cover_image.file, cover_flg: true)
        end
      elsif profile_image.image.present?
        profile_image.update!(order_num: 1, cover_flg: false)
      end
    end
  end
end
