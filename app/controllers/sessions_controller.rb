class SessionsController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.find_by(email: params[:session][:email])
    if @user && @user.authenticate( params[:session][:password])
      
      if @user.activated? 
          
        login_session(@user)
        login_cookies(@user)
        flash[:info] = "ログインしました"
        redirect_to @user
      else
        message  = "アカウントが有効になっていませんメールを確認してください"
        flash[:danger] = message
        redirect_to login_path
      end
    else
      flash[:danger] = "メールまたわパスワードが間違っています"
      render "new"
    end
  end
  
  def destroy
    logout if current_user #ログインしてたら実行しないようにする
    
    flash[:info] = "ログアウトしました"
    redirect_to login_path
  end
end
