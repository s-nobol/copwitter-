require 'test_helper'

class UserPostTest < ActionDispatch::IntegrationTest
  
  # 記事投稿のテスト
  def setup
    @user = users(:first_user)
    @other_user = users(:second_user)
  end
  
  test "@user_page post?" do
    
    # user_showにアクセス
    login_as(@user)
    get user_path(@user)
    assert_template "users/show"
    
    # postの数だけテスト
    @user.posts.page(1).per(6).each do |post|
      assert_match post.content, response.body
      # assert_equal 1,2,  "user_post #{post.content}"
    end
  end
  
  test "user_createpost" do
    
    # user_showにアクセス
    login_as(@user)
    get user_path(@user)
    assert_template "users/show"
    
    # 間違った記事を送信（はじかれる）
    assert_no_difference "Post.count" do
      post posts_path , params: { post: { content: "" } }
    end
    assert_redirected_to @user
    assert_not flash.empty? ,"flash = #{flash[:notice]}"
    
    # 正しい記事を送信
    content = "test_post"
    assert_difference "Post.count", 1 do
      post posts_path ,params: { post: { content: content } }
    end
    
    # ものとのページが表示されるか？
    assert_redirected_to @user
    # assert flash.empty? ,"flash = #{flash[:notice]}"
    follow_redirect!
    assert_template "users/show"
    
    # Viewは増えているか？
    assert_match content, response.body
  end
  
  test "delete_post" do

    # @other_user_showにアクセス
    login_as(@other_user)
    get user_path(@user)
    assert_template "users/show"
    
    # post作成
    post = posts(:first_post)
    post2 = posts(:last_post)
    
    # 間違った記事を送信（はじかれる）
    assert_no_difference "Post.count" do
      delete post_path(post)
    end
    assert_redirected_to root_path
    
    # 正しい記事を送信
    assert_difference "Post.count" , -1 do
      delete post_path(post2)
    end
    assert_not flash.empty? ,"flash = #{flash[:notice]}"
    assert_redirected_to @other_user
  end
  
  test "other_user not_delete_button" do
    
    # 自分のページにアクセス（削除ボタンが表示される）
    login_as(@user)
    get user_path(@user)
    assert_template "users/show"
    @user.posts.page(1).per(6).each do |post|
      assert_match post.content, response.body
      assert_select 'a', text: '削除する'
    end
    
    # 他人のページアクセス（削除ボタンは表示されない）
    get user_path(@other_user)
    assert_template "users/show"
    @other_user.posts.page(1).per(6).each do |post|
      assert_match post.content, response.body
      assert_select 'a', text: '削除する', count: 0
    end
  end
end
