class PostsController < ApplicationController
  before_action :logged_in?, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def create
    @post = current_user.posts.build(post_params) 
    if @post.save
      flash[:notice] = "記事の作成"
      redirect_to current_user
    else
      @feed_items = []
      flash[:notice] = "内容がありません"
      redirect_to current_user
    end
  end
  
  def destroy
    @post.destroy
    flash[:notice] = "記事を削除しました"
    redirect_to current_user
  end
  
  def show
    @posts = Post.find(params[:id])
    @users = User.find(@posts.user_id)
    #まだ作成中@comments = @post.comments
  end
  
  
  private
  
    # 記事のパラメータ
    def post_params
      params.require(:post).permit(:content)
    end
    
    # 削除する記事が自分のではなければはじく
    def correct_user
        @post = current_user.posts.find_by(id: params[:id])
        redirect_to root_url if @post.nil?
    end
end
