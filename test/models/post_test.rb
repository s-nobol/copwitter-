require 'test_helper'

class PostTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:first_user)
    @post = @user.posts.build(content: "Lorem ipsum")
  end
  
  test "post.valid?" do
    assert @post.valid?
  end
  
  test "user_idempty?" do
    @post.user_id = nil
    assert_not @post.valid? ,"post.save? = #{@post.save}"
  end
  
  test "content_empty?" do
    @post.content =""
    assert_not @post.valid? ,"post.save? = #{@post.save}"
  end
  
  test "length < 256" do
    @post.content ="a"*257
    assert_not @post.valid? ,"post.save? = #{@post.save}"
  end
  
  # ポストの並びが新しい順になっているか？
  test "last_post_is first_time?" do
    assert_equal posts(:last_post), Post.first
  end
end
