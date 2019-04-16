Rails.application.routes.draw do
  
  # 企業ポリシーページ
  get 'static_pages/home'
  get 'static_pages/about'
  get 'static_pages/hepl'
  get 'static_pages/agreement'
  get 'static_pages/policy'
  get 'static_pages/corporate'
  
  # ログイン
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  # サインアップ
  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'
  
  # 画像更新
  post 'update_image', to: 'users#image'
  # ルートページ
  root 'static_pages#home'
  
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :users 
  resources :activations,         only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :posts,               only: [:show, :create, :destroy]
  resources :relationships,       only: [:create, :destroy]

end

# herokuインストール
# $ source <(curl -sL https://cdn.learnenough.com/heroku_install)


#ユーザー作成(名前、メール、パスワード)
# rails g model User name:string email:string image:string password_digest:string 
# rails g controller Users new show edit index 

# ログイン機能作成(セッションページクッキー作成)
# git checkout -b create-login
# rails g controller Sessions new
# rails g migration add_cookies_to_users cookies_digest:string

# editページの作成
# Statusモデル作成
# rails g model Status address:string barthday:string link:string

# mailerの追加
# rails g controller Activations edit
# rails g migration add_activation_to_users activation_digest:string activated:boolean 
# rails g mailer UserMailer activation password_reset

# Post作成クラスの追加
# rails g model Post content:text user:references
# rails g controller Posts 

# Postドロップダウンメニュー　（削除　通報）
# post_formは自分以外のユーザーの時は表示されないようにする。（もしくはべつに設定する）

# follow機能の作成
# rails g model Relationship follower_id:integer followed_id:integer
# rails g controller Relationships

# password_resetの作成
# rails g controller PasswordResets new edit --no-test-framework
# rails g migration add_reset_to_users reset_digest:string reset_sent_at:datetime

# image機能作成（post, user）
# rails g migration add_picture_to_posts picture:string
# rails g migration add_image_to_users image:string background_image:string (address　link　barthday message)追加

# userImagerUploader作成
# rails generate uploader Image
# rails generate uploader BackgroundImage