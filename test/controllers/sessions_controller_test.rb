require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  # セッションコントローラーが正しく機能しているか？
  test "should get login" do
    get login_path
    assert_response :success
  end 
  

end
