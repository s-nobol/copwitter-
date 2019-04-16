require 'test_helper'

class EditUserTest < ActionDispatch::IntegrationTest
  # これはEditページのテスト
  def setup
    @user = users(:first_user)
    @other_user = users(:second_user)
  end
  
  test "user_edit" do
    
    # 初期設定、ログイン
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
    patch user_path(@user) ,params: { user: { name: name, edit: email,
                                              message: "test_msg", address: address, 
                                              link: "test.com" , barthday: "1/25" } }
    assert_redirected_to @user
    follow_redirect!
    assert_match name, response.body
    assert_match email, response.body
    
    @user.reload
    assert_equal name, @user.name
    # assert_equal email, @user.email, "email? = #{@user.reload.email}"
  end
  
  # 別のログインユーザーからのアクセス
  test "differ_login_user" do
    
    # ユーザーの初期設定
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
  
  # 画僧が編集できるか
  test "edit_user_image" do
    
    # editページにアクセス
    login_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    
    # 無効なデータ送信
    post update_image_path, params: { user: { image: "" } }
    assert_redirected_to edit_user_path(@user)
    assert_not flash.empty? , "flash = #{flash[:notice]}"
    
    post update_image_path, params: { user: { background_image: "dada.ctc" } }
    assert_redirected_to edit_user_path(@user)
    assert_not flash.empty? , "flash = #{flash[:notice]}"
    
    post update_image_path, params: { user: nil }
    assert_redirected_to edit_user_path(@user)
    assert_not flash.empty? , "flash = #{flash[:notice]}"
    
    # 正しいパスを送信
    image = "test.jpg"
    post update_image_path, params: { user: { background_image: image } }
    assert_redirected_to edit_user_path(@user)
    assert_not flash.empty? , "flash = #{flash[:notice]}"
    @user.reload
    # assert_equal image, @user.background_image
  end
end
