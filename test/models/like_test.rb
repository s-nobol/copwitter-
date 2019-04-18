require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
    @user = users(:first_user)
    @post = posts(:first_post)
    # @like = @post.likes(user: @user)
    @like = Like.new(user: @user, post: @post)
  end
  
  test "like.valid?" do
    assert @like.valid?, "like_save #{@like.save}"
  end
  
  test "like_user.valid?" do
    @like.user_id = nil
    assert_not @like.valid?, "like_save #{@like.save}"
  end
  test "like_post.valid?" do
    @like.post_id = nil
    assert_not @like.valid?, "like_save #{@like.save}"
  end
  
  # おなじユーザーのいいね
  test "same_user_valid?" do
    assert @like.valid?, "like_save #{@like.save}"
    @like.save
    @like2 = Like.new(user: @user, post: @post)
    assert_not @like2.valid? , "like_save #{@like2.save}"
  end
  
  
end
