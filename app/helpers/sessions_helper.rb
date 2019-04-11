module SessionsHelper
  
  # ログイン
  def login_session(user)
    session[:user_id] = user.id
  end
  
  def login_cookies(user)
    user.create_cookies_digest
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:token] = user.cookies_token
  end
  
  
  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])      
    elsif ( user_id = cookies.signed[:user_id] )
      user = User.find(user_id)
      if user && user.authenticated?(:cookies, cookies[:token])
        login_session(user)
        @current_user = user 
      end
    end
  end
  
  
  # ログアウト
  def logout_session
    session.delete(:user_id)  
  end
  
  def logout_cookies
    current_user.foget
    cookies.delete(:user_id)
    cookies.delete(:token)
    @current_user = nil
  end
  
  def logout
    logout_cookies
    logout_session
  end
  
  # 正しいユーザーか確認(current_user?にしてもいい)
  def current_post?(post_user)
    if !current_user.nil? 
      if current_user == post_user
        post_user
      end
    end
  end
  
end