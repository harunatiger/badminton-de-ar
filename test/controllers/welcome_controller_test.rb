require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pickups)
  end
  test "should get random pickups" do
    get :index
    pickups = Pickup.find(Pickup.where.not(selected_listing: nil).pluck(:id))
    assert_not_nil pickups
  end
end
