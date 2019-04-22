class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] 
  before_action :password_empty, only: [:update]

  def new
  end
  
  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user
      
      # メール送信
      @user.create_password_reset_digest
      UserMailer.password_reset(@user).deliver_now
      # url = edit_password_reset_url(@user.reset_token, email: @user.email)
      
      # ルートページにリダイレクト
      flash[:info] = "メールを送信しました 確認してください"
      redirect_to root_path
    else
      flash[:danger] = "該当するユーザーが見つかりません"
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user && @user.update_attributes(user_params) 
      
      # ログインする
      login_session(@user)
      login_cookies(@user)
      
      flash[:success] = "パスワードを更新しました"
      redirect_to @user
    else
      render "edit"
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    # 正しいユーザーか確認
    def valid_user
      @user = User.find_by(email: params[:email])
      unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
        redirect_to root_path
      end
    end
    
    # 期限切れ確認
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
    
    # パスワードが空白検知
    def password_empty
      if params[:user][:password].empty?                
        @user.errors.add(:password, :blank)
        render 'edit'
      end
    end
   
end
