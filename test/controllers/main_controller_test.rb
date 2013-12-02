require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "should get shares" do
    get :shares
    assert_response :success
  end

end
