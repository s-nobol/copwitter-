class LikesController < ApplicationController
  before_action :logged_in? , only: [:create, :destroy, :show]
  before_action :correct_user, only: [:show]
  
  def create
    @post = Post.find(params[:id])
    @like = current_user.likes.create(post: @post)
    respond_to do |format|
      if @like.save 
        format.html { redirect_to user_path(current_user) }
        format.js
      end
    end
  end
  
  def destroy
    @like = Like.find(params[:id])
    @post = Post.find(@like.post_id)
    @like.destroy
  
    respond_to do |wants|
      wants.html { redirect_to user_path(current_user) }
      wants.js
    end
  end
  
  
  # いいね一覧ページどうするか？
  def show
    @user = User.find(params[:id])
    likes_ids = @user.likes.map(&:post_id) 
    @posts = Post.where("id IN (?)", likes_ids).page(params[:page]).per(6)
  end
end

# いいねが押せるのはpost_Showの時のみ