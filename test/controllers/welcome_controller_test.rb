require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get random pickups" do
    get :index
    pickups = Pickup.find(Pickup.where.not(selected_listing: nil))
    assert_not_nil pickups
  end

end
