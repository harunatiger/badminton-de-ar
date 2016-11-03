ActiveAdmin.register Spot do

  index do
    Spot.column_names.each do |col|
      if col == 'user_id'
        column col
        column 'profile_id' do |spot|
          profile = Profile.find_by_user_id(spot.user_id)
          link_to profile.id, profile_path(profile.id), target: '_blank' if profile.present?
        end
      else
        column col
      end
    end
    actions defaults: true do |spot|
      if spot.admin_closed_at.blank?
        item 'Close', close_admin_spot_path(spot), method: :PATCH, class: 'view_link member_link', data: {confirm: 'このスポットを非公開にします。よろしいですか？'}
      else
        item 'Open', open_admin_spot_path(spot), method: :PATCH, class: 'view_link member_link', data: {confirm: 'このスポットを公開します。よろしいですか？'}
      end
    end
  end
  
  csv :force_quotes => false do
    Spot.column_names.each do |col|
      if col == 'user_id'
        column col
        column 'profile_id' do |listing|
          profile = Profile.find_by_user_id(listing.user_id)
          profile.id if profile.present?
        end
      else
        column col
      end
    end
  end
  
  member_action :close, method: :patch do
    spot = Spot.find_by_id(params[:id])
    spot.update(admin_closed_at: Time.zone.now)
    redirect_to admin_spots_path
  end
  
  member_action :open, method: :patch do
    spot = Spot.find_by_id(params[:id])
    spot.update(admin_closed_at: nil)
    redirect_to admin_spots_path
  end
end
