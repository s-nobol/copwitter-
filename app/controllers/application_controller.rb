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
end
