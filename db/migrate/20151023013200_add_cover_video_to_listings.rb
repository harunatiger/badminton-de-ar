class AddCoverVideoToListings < ActiveRecord::Migration
  def change
    add_column :listings, :cover_video            , :text, after: :cover_image_caption, default: ''
    add_column :listings, :cover_video_description, :text, after: :cover_video        , default: ''
  end
end
