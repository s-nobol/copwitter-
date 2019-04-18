class ApplicationController < ActionController::Base
  
  include SessionsHelper
  
  # ユーザーがログインしているか
  def logged_in?
    !current_user.nil?
    if current_user.nil?
      flash[:notice] = "ログインしていません"
      redirect_to login_path
    end
  end
  
  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      flash[:notice] = "アクセスできません"
      redirect_to(root_url) 
    end
  end
end
