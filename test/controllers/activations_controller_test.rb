require 'test_helper'

class ActivationsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get edit_activation_url(1, email: "user@test.com")
    # assert_equal 1, 2, "#{edit_activation_url(1, email: "user@test.com")}"
    # assert_response :success
  end

end
