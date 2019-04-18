require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup 
    @post = posts(:first_post)
    @user = users(:first_user)
    @comment = @post.comments.new(content: "testcomment", user: @user)
   
  end
  
  test "comment.valid?" do
    assert @comment.valid? , "@comment.save? = #{@comment.save    }"
  end
  
  test "name.empty?" do
    @comment.content =""
    assert_not @comment.valid? , "@comment.save? = #{@comment.save}"
  end
  
  test "comment >256" do
    @comment.content ="a"*257
    assert_not @comment.valid? , "@comment.save? = #{@comment.save}"
  end
end
