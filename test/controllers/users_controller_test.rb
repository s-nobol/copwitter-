require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:first_user)
  end
  
  test "should get new" do
    get new_user_path
    assert_response :success
  end
  
  # ログインしてないとはじかれる
  # test "no_login_user get_show" do
  #   get user_path(@user)
  #   assert_redirected_to login_path 
  #   login_as(@user)
  #   get user_path(@user)
  #   assert_response :success
  # end
  
  test "no_login_user get_edit" do
    get edit_user_path(@user)
    assert_redirected_to login_path 
    login_as(@user)
    get edit_user_path(@user)
    assert_response :success
  end
  
  
end
