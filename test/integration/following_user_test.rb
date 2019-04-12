require 'test_helper'

class FollowingUserTest < ActionDispatch::IntegrationTest

  # ユーザーフォローテスト
  def setup
    @user = users(:first_user)
  end
  
  test "user_following_other_user?" do
    
    # ログイン
    login_as(@user)
    @other_user = users(:second_user)
    
    # @other_userは@userにフォローされているか確認
    assert @other_user.followers.include?(@user)
    
    # フォロー解除できているか確認する
    @user.unfollow(@other_user)
    assert_not @user.following?(@other_user)
    
    # フォローできているか確認する
    @user.follow(@other_user)
    assert @user.following?(@other_user)
    
    # relationship.ymlを設定したので設定入れ替えた
  end
  
  # followページのテスト
  test "user_following_page" do
    login_as(@user)
    get following_user_path(@user)
    assert_template "users/index"
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_match user.name, response.body
    end
  end
  
  test "user_followers_page" do
    login_as(@user)
    get followers_user_path(@user)
    assert_template "users/index"
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_match user.name, response.body
    end
  end
  
  # feedが正しく機能しているか？
  test "user_show follower_feed" do
    @second_user = users(:second_user)
    @taro = users(:taro)
    @satoshi = users(:satoshi)
    
    # @userには@second_userの記事が表示される
    @second_user.posts.each do |follower_post|
      assert @user.feed.include?(follower_post) 
    end
    
    # @second_userは@userをフォローしてないので記事は表示されない
    @user.posts.each do |follower_post|
      assert_not @second_user.feed.include?(follower_post) 
    end
  end
end
