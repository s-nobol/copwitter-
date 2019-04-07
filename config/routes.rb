Rails.application.routes.draw do
  
  # 企業ポリシーページ
  get 'static_pages/home'
  get 'static_pages/about'
  get 'static_pages/hepl'
  get 'static_pages/agreement'
  get 'static_pages/policy'
  get 'static_pages/corporate'
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  # ルートページ
  root 'static_pages#home'
  resources :users 
end


#ユーザー作成(名前、メール、パスワード)
# rails g model User name:string email:string image:string password_digest:string 
# rails g controller Users new show edit index 

# ログイン機能作成(セッションページクッキー作成)
# git checkout -b create-login
# rails g controller Sessions new

# クッキーの作成
# rails g migration add_cookies_to_users cookies_digest:string
