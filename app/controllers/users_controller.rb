class UsersController < ApplicationController
  before_action :logged_in? ,only: [:index, :edit, :update, :following, :followers, :image]
  before_action :correct_user,   only: [:edit, :update]
  before_action :no_image, only: [:image]
  
  def new
    @user = User.new
  end
  
  # やく150msかかる（なぜか？）
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
        
        flash[:info] = "メールを送信しました確認してください"
        wants.html { redirect_to(root_path) }
        wants.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        flash[:danger] = "ユーザー作成できません"
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
      if @user.update_attributes(user_params)
        flash[:success] = "ユーザー情報を編集しました"
        wants.html { redirect_to(@user) }
        wants.xml  { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  # もしクライアントユーザーでなかったらはじく
  def image
    if current_user.update_attributes(image_params)
      flash[:success] = "画像を更新しました"
      redirect_to edit_user_path(current_user)
    else
      flash[:success] = "画像を更新できませんでした"
      redirect_to edit_user_path(current_user)
    end
  end
  
  # フォロワーページ
  def following
    @title = "フォロー"
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page]).per(6)
    render 'index'
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users  = @user.followers.page(params[:page]).per(6)
    render 'index'
  end
  
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :message, :address, :link, :barthday)
    end

    def image_params
      params.require(:user).permit(:image, :background_image)
    end
    
    
    # もし画像がなければもとに戻す
    def no_image
      unless params[:user] 
        flash[:danger] = "画像が挿入されていません"
        redirect_to edit_user_path(current_user)
      end
    end
end
