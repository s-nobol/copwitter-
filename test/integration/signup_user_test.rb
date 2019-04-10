require 'test_helper'

class SignupUserTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end
  # ユーザー作成テスト
  test "signup_user_test" do
    get new_user_path
    assert_template "users/new"
    
    name = "first_user"
    email = "first_user@test.com"
    # ユーザー作成(はじかれる)
    assert_no_difference "User.count" do
      post users_path, params: { user: { name: name, email: "", password: ""  } }
    end
    assert_template "users/new"
    
    # ユーザー作成(成功)
    assert_difference "User.count", 1 do
      post users_path, params: { user: { name: name, email: email, password: "password" } }
    end
    
    assert_not flash.empty?
    follow_redirect!
    # assert_template "users/show"
    # assert is_logged_in?
  end
  
  # メールが正しく送信されているか？
  test "user_send_mail??" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password"} }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    
    # 有効化していない状態でログインしてみる
    login_as(user)
    assert_not is_logged_in?
    
    # 有効化トークンが不正な場合
    get edit_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    
    # トークンは正しいがメールアドレスが無効な場合
    get edit_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    
    # 有効化トークンが正しい場合
    get edit_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
 
  end
end
# first_user: 
  # name: first_user
  # email: first_user@test.com