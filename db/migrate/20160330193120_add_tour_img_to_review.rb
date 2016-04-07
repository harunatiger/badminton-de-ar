class AddTourImgToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :tour_image, :string, default: ''
  end
end
