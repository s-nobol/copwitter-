require 'test_helper'

class SignupUserTest < ActionDispatch::IntegrationTest
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
    assert_template "users/show"
    assert is_logged_in?
    
    assert_match name, response.body
  end
  
  # エラーメッセージが表示されるか確認
  test "errors_message" do
    
  end
end
