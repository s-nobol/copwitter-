class UsersController < ApplicationController
  before_action :logged_in? ,only: [:index, :edit, :update, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(6)
  end

  def edit
    @user = User.find(params[:id])
    # @status = @users.status
  end

  def index
    @users = User.page(params[:page]).per(6)
  end
  
  def create
    @user = User.new(user_params)
    respond_to do |wants|
      if @user.save
        
        # アカウント有効メール送信
        @user.create_activation_digest
        UserMailer.activation(@user).deliver_now
        @user.create_status
        
        flash[:notice] = "メールを送信しました #{ edit_activation_url(@user.activation_token, email: @user.email)}"
        wants.html { redirect_to(root_path) }
        wants.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        flash[:notice] = "ユーザー作成できません"
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
  
    respond_to do |wants|
      wants.html { redirect_to(users_url) }
      wants.xml  { head :ok }
    end
  end
  
  def update
    @user = User.find(params[:id])
    
    respond_to do |wants|
      if @user.update_attributes(user_params) && @user.status.update_attributes(status_params)
        flash[:notice] = "編集しました　#{ params[:user] } ステータス#{ params[:status]}"
        wants.html { redirect_to(@user) }
        wants.xml  { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # フォロワーページ
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page]).per(6)
    render 'index'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users  = @user.followers.page(params[:page]).per(6)
    render 'index'
  end
  
  private
    def user_params
       params.require(:user).permit(:name, :email, :password)
    end
    
    def status_params
       params.require(:status).permit(:address, :link, :barthday)
    end
    
     # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end
end
