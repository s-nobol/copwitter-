require 'test_helper'

class EditUserTest < ActionDispatch::IntegrationTest
  # これはEditページのテスト
  def setup
    @user = users(:first_user)
    @other_user = users(:second_user)
  end
  
  test "user_edit" do
    
    # 初期設定、ログイン
    @user.create_status
    assert_not @user.status.nil? ,"@user.status #{@user.status}"
    login_as(@user)
    
    # @userを編集させる
    get edit_user_path(@user)   
    assert_template "users/edit"
    
    # 失敗するパスを通す
    patch user_path(@user) ,params: { user: { name: "", edit: ""}  }
    assert_template "users/edit"
    
    # 成功するパス通す
    name = "test_name"
    email = "email@test.com"
    address = "tokyo"
    patch user_path(@user) ,params: { user: { name: name, edit: email} , 
                                      status: { address: address, link: "test.com" , barthday: "1/25"}}
    assert_redirected_to @user
    follow_redirect!
    assert_match name, response.body
    assert_match email, response.body
    
    @user.reload
    assert_equal name, @user.name
    # assert_equal email, @user.email, "email? = #{@user.reload.email}"
    assert_equal address, @user.status.address 
  end
  
  # 別のログインユーザーからのアクセス
  test "differ_login_user" do
    
    # ユーザーの初期設定
    @user.create_status
    @other_user.create_status
    login_as(@other_user)
    assert is_logged_in?
    
    # editページにアクセス
    get edit_user_path(@user)
    assert_redirected_to root_path
    
    # updateにアクセス
    patch user_path(@user), params: { user: { name: "name", edit: "example@test.com"} , 
                                      status: { address: "toyko", link: "test.com" , barthday: "1/25"}}
    assert_redirected_to root_path
    
  end
end
