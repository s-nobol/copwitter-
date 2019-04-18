require 'test_helper'

class UserCommentTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:first_user)
    @other = users(:second_user)
    @post = posts(:first_post)
    @second_user_post = posts(:last_post)
  end
  
  test "post_comment" do
    login_as(@user)
    get post_path(@post)
    assert_template "posts/show"
    
    # 無効なコメントを送信　はじかれる
    assert_no_difference "Comment.count" do
      post comments_path, params: { comment: { content: "" }, post_id: @post.id }
    end
    assert_template "posts/show"
    assert_select 'div#error_explanation'    
    
    # 無効なコメントを送信　はじかれる]
    comment = "5"*257
     assert_no_difference "Comment.count", 1  do
      post comments_path, params: { comment: { content: comment }, post_id: @post.id }
    end
    assert_template "posts/show"
    assert_select 'div#error_explanation'    
    
    # 有効なコメントを送信　通る
    comment =  "test_comment"
    post comments_path, params: { comment: { content: comment }, post_id: @post.id }
    assert_redirected_to @post
    follow_redirect!
    assert_not flash.empty?
    
    assert_select 'a', text: '削除'

    # コメントを削除　有効
    @comment = @post.comments.page(1)
    @comment.each do |msg|
      assert_difference "Comment.count", -1 do
        delete comment_path(msg)
      end
    end
    
    # コメントを削除　有効
    # assert_select 'a', text: 'delete'
    # first_micropost = @user.microposts.paginate(page: 1).first
    # assert_difference 'Micropost.count', -1 do
    #   delete micropost_path(first_micropost)
    # end
  end
  
  # 別のユーザーのページアクセスして削除してみる
  test "other_user_post_comment" do
    login_as(@user)
    get post_path(@second_user_post)
    assert_template "posts/show"
    
    # 無効なコメントを送信　はじかれる
    assert_no_difference "Comment.count" do
      post comments_path, params: { comment: { content: "" }, post_id: @second_user_post.id }
    end
    assert_template "posts/show"
    assert_select 'div#error_explanation'    
    
    # 無効なコメントを送信　はじかれる]
    comment = "5"*257
     assert_no_difference "Comment.count", 1  do
      post comments_path, params: { comment: { content: comment }, post_id: @second_user_post.id }
    end
    assert_template "posts/show"
    assert_select 'div#error_explanation'    
    
    # 有効なコメントを送信　通る
    comment =  "test_comment"
    post comments_path, params: { comment: { content: comment }, post_id: @second_user_post.id }
    assert_redirected_to @second_user_post
    follow_redirect!
    assert_not flash.empty?
    
    # assert_not_empty 'a', text: '削除'
    
    # コメントを削除　無効
    @comment = @post.comments.page(1)
    @comment.each do |msg|
      assert_no_difference "Comment.count" do
        delete comment_path(msg)
      end
    end
    
    # コメントを削除　有効
    # assert_select 'a', text: 'delete'
    # first_micropost = @user.microposts.paginate(page: 1).first
    # assert_difference 'Micropost.count', -1 do
    #   delete micropost_path(first_micropost)
    # end
  end
end
