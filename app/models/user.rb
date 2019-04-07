class User < ApplicationRecord
  
  
  validates :name ,presence: true, length: { maximum: 55 }
  validates :email ,presence: true
  
  has_secure_password
  validates :password, presence: true, length: { minimum: 5 }
  
  attr_accessor :cookies_token
  
  def create_token
    SecureRandom.urlsafe_base64
  end
  
  
  # クッキーをデータべースに保存
  def create_cookies_digest
    self.cookies_token = create_token
    update_attribute(:cookies_digest, User.digest(cookies_token))
  end 
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(token)
    return false if token.nil?
    BCrypt::Password.new(cookies_digest).is_password?(token)
  end
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  def foget
    update_attribute( :cookies_digest, nil )
  end
end
