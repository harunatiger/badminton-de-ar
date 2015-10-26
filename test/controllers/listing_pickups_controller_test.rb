require 'test_helper'

class ListingPickupsControllerTest < ActionController::TestCase

  test "Can get parameter" do
    get :manage, format: :json
    assert_response :success
    assert_not_nil assigns(:listing)
  end
=begin
  test "Can render correct layout" do
    get :manage, format: :json
    assert_template layout: "listing_pickups/manage", partial: "_form"
  end

  test "Can create pickup_category and record count is incremented then redirecting" do
    assert_difference('pickup_categories.count') do
      post :update, :listing => { }
    end

    assert_redirected_to manage_listing_listing_pickups_path(assigns(:listing))
    assert_equal Settings.listing_pickups.save.success, flash[:notice]
  end


  test "Can not create pickup_category and not change the record count then redirecting" do
    assert_difference('pickup_categories.count') do
      post :update, :listing => { }
    end

    assert_redirected_to manage_listing_listing_pickups_path(assigns(:listing))
    assert_equal Settings.listing_pickups.save.failure, flash[:notice]
  end
=end
end