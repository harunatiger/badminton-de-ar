class AddColumnsToNgweeks < ActiveRecord::Migration
  def change
    add_column :ngevent_weeks, :mode, :integer, default: 0, null: false, index: true
    add_column :ngevent_weeks, :user_id, :integer

    NgeventWeek.all.each do |nw|
      listing_id = nw.listing_id
      if listing_id.present?
        user = Listing.where(id: listing_id).pluck(:user_id)
        if user.present?
          user_id = user[0]
        else
          user_id = 0
        end
        nw.update!(user_id: user_id)
      end
    end
  end

end
