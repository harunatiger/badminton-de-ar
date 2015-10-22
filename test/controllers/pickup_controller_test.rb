require 'test_helper'

class PickupControllerTest < ActionController::TestCase

  test "Can get parameter" do
    get :manage
    assert_response :success
    assert_not_nil assigns(:listing)
  end

  test "Can render correct layout" do
    get :manage
    assert_template layout: "pickup_categories/manage", partial: "_form"
  end

  test "Can create pickup_category and record count is incremented then redirecting" do
    assert_difference('pickup_categories.count') do
      post :create, :listing => { }
    end

    assert_redirected_to manage_listing_pickup_categories_path(assigns(:listing))
    assert_equal Settings.listing_images.save.success, flash[:notice]
  end

  test "Can destroy pickup_category and record count is decremented then redirecting" do
    assert_difference('pickup_categories.count', -1) do
      delete :destroy, :id => :listing.id
    end

    assert_redirected_to manage_listing_pickup_categories_path(assigns(:listing))
    assert_equal 'ListingImage was successfully destroyed.', flash[:notice]
  end

  test "Can not create pickup_category and not change the record count then redirecting" do
    assert_difference('pickup_categories.count') do
      post :create, :listing => { }
    end

    assert_redirected_to manage_listing_pickup_categories_path(assigns(:listing))
    assert_equal Settings.listing_images.save.failure, flash[:notice]
  end

  test "Can not destroy pickup_category and not change the record count then redirecting" do
    assert_difference('pickup_categories.count', -1) do
      delete :destroy, :id => :listing.id
    end

    assert_redirected_to manage_listing_pickup_categories_path(assigns(:listing))
    assert_equal 'ListingImage was failed destroyed.', flash[:notice]
  end

end