require 'test_helper'

class LoginUserTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:first_user)
  end
  # ログインユーザーのテスト
  test "user_login" do
    get login_path
    assert_template "sessions/new"
    
    # 通らないパス
    post login_path , params: { session: { email: "",password: "" } } 
    assert_template "sessions/new"
    
    # 通るパス
    post login_path , params: { session: { email: @user.email ,password: "password" } } 
    assert_redirected_to @user
    assert_not flash.empty?
    
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", new_user_path, count: 0
    # assert_select "a[href=?]", user_path(@user) 
    # assert_select "a[href=?]", edit_user_path
    assert is_logged_in? , "login = #{is_logged_in?}"
    
  end
  
  # ログアウトのテスト
  test "user_logout" do
    
    # ログインする
    get login_path
    assert_template "sessions/new"
    
    post login_path , params: { session: { email: @user.email, password: "password"} }
    assert is_logged_in?
    
    # ユーザーがログイン状態か確認
    # login_as(@user)
    # ログアウトする
    delete logout_path(@user)
    assert_redirected_to login_path
    assert_not is_logged_in? , "login = #{is_logged_in?}"
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", user_path(@user) , count: 0
    # login_as?(@user)
    
    delete logout_path(@user)
    assert_redirected_to login_path
  end
  
  # クッキーが正しく作成されるか？
  test "user_login create_cookies?" do
    login_as(@user)
    assert_not_empty  cookies[:token] ,"cookies_token = #{cookies[:token]}"
  end
  
  test "user_login create_cookies" do
    login_as(@user)
    assert_not_empty  cookies[:token] ,"cookies_token = #{cookies[:token]}"
    delete logout_path
    assert_empty  cookies[:token] ,"cookies_token = #{cookies[:token]}"
  end
end
