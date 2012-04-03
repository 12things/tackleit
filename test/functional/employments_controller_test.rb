require 'test_helper'

class EmploymentsControllerTest < ActionController::TestCase
  test "should get create_multiple" do
    get :create_multiple
    assert_response :success
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

end
