require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:first_user)
  end
  
  test "passowrd_rest" do
    
    get new_password_reset_path
    assert_template "password_resets/new"
    
    # 間違ったメールを送信
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template "password_resets/new"
    
    # 正しいメールを送信
    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_redirected_to root_path
    
    # パスワード再設定テスト
    
    # 無効なメールで送信
    user = assigns(:user)
    # assert_equal 1,2, "user_reset_token = #{user.reset_token}"
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_path
    
    # トークンが違う
    get edit_password_reset_path(123, email: user.email)
    assert_redirected_to root_path
    
    # 有効なパス
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template "password_resets/edit"
    
    # パスワード入力テスト
    
    # 無効なパスワードを送信
    patch password_reset_path(user.reset_token), params: { email: user.email, 
                                               user: { password: "", 
                                                        password_confirmation: "" } }  
    assert_template "password_resets/edit"
    
    # 無効なパスワードを送信
    patch password_reset_path(user.reset_token), params: { email: user.email, 
                                               user: { password: "", 
                                                        password_confirmation: "" } }   
    assert_template "password_resets/edit"
    
    # 有効なパスワードを送信
    patch password_reset_path(user.reset_token), params: { email: user.email, 
                                               user: { password: "password", 
                                                        password_confirmation: "password" } }  
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end
