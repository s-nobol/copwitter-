Rails.application.routes.draw do
  
  # 企業ポリシーページ
  get 'static_pages/home'
  get 'static_pages/about'
  get 'static_pages/hepl'
  get 'static_pages/agreement'
  get 'static_pages/policy'
  get 'static_pages/corporate'
  
  # ルートページ
  root 'static_pages#home'
end


# とりあえず一通りアップロードしてみる
# Static_pages の作成
# rails g controller StaticPages home about hepl agreement policy corporate
# gitの設定
# $ git config --global user.name "kiyo1301"
# $ git config --global user.email ka1301@outlook.jp