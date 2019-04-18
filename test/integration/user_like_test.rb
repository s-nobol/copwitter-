require 'test_helper'

class UserLikeTest < ActionDispatch::IntegrationTest
  # いいね機能の確認テスト
  
  def setup
    @user = users(:first_user)
    @post = posts(:first_post) #first_postはfirst_userのPost
    login_as(@user)
  end
  
  
  
  # いいねを押す（html編）
  test "like_test" do
    assert_difference "Like.count", 1 do
      post likes_path, params: { id: @post.id }
    end
    
    @like = @post.likes.find_by(user: @user)
    assert_difference "Like.count", -1 do
      delete like_path(@like), params: { id: @like.post_id }
    end
  end
  
  
  # いいねを押す（Ajax編）
  test "ajax like_test" do
    assert_difference "Like.count", 1 do
      post likes_path , xhr: true, params: { id: @post.id }
    end
     
     
    @like = current_user.likes.find_by(post: @post)
    assert_difference "Like.count", -1 do
       delete like_path(@like), xhr: true, params: { id: @like.post_id }
    end
  end
  
  
  # べつのユーザーのいいね
  test "other_post like_test" do
    @other_user = users(:second_user)
    @other_post = posts(:last_post)
    assert_difference "Like.count", 1 do
      post likes_path, params: { id: @other_post.id }
    end
    
    @like = @other_post.likes.find_by(user: @user)
    assert_difference "Like.count", -1 do
      delete like_path(@like), params: { id: @like.post_id }
    end
  end
  
  test "user duoble_create_post" do
    assert_difference "Like.count", 1 do
      post likes_path, params: { id: @post.id }
    end

    # assert_no_difference "Like.count" do
    #   post likes_path, params: { id: @post.id }
    # end
  end
  
end
