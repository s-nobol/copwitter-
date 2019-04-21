class ActivationsController < ApplicationController
  
  
  def edit
    @user = User.find_by(email: params[:email])
    if @user && !@user.activated? && @user.authenticated?(:activation, params[:id])
      # ユーザーの有効化
      @user.activation
      
      # ログインする
      login_session(@user)
      login_cookies(@user)
      flash[:info] = "こんにちは#{@user.name}さんアカウントは有効化されました"
      redirect_to @user
    else
      flash[:danger] = "間違ったメールアドレスです"
      redirect_to root_path
    end
  end
  
end
