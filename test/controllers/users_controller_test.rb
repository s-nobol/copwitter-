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
  test "no_login_user get_edit" do
    get edit_user_path(@user)
    assert_redirected_to login_path 
    login_as(@user)
    get edit_user_path(@user)
    assert_response :success
  end
  
  test "no_following_user" do
    get following_user_path(@user)
    assert_redirected_to login_path
  end
  
  test "no_followers_user" do
    get followers_user_path(@user)
    assert_redirected_to login_path
  end
  
  
end
