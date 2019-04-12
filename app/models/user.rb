class User < ApplicationRecord
  has_one :status, dependent: :destroy
  has_many :posts, dependent: :destroy
  
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy            
                                   
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  
  validates :name ,presence: true, length: { maximum: 55 }
  validates :email ,presence: true
  
  has_secure_password
  validates :password, presence: true, length: { minimum: 5 }, allow_nil: true
  
  attr_accessor :cookies_token, :activation_token
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークン作成
  def create_token
    SecureRandom.urlsafe_base64
  end
  
  # クッキーをデータべースに保存
  def create_cookies_digest
    self.cookies_token = create_token
    update_attribute(:cookies_digest, User.digest(cookies_token))
  end 
  
  # Activetion_tokenをデータべースに保存
  def create_activation_digest
    self.activation_token = create_token
    update_attribute(:activation_digest, User.digest(activation_token))
  end 
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    return false if token.nil?
    digest = send("#{attribute}_digest") 
    return false if digest.nil? #追加（意味ないかも？）
    
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  def foget
    update_attribute( :cookies_digest, nil )
  end
  
  def activation
    update_attribute( :activated, true )
  end
  
  def feed
    Post.where("user_id = ?", id) #self.id
  end
  
   # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
  
  # ユーザーのステータスフィードを返す
  def feed
    following_ids = "SELECT followed_id FROM relationships
                    WHERE follower_id = :user_id"
    Post.where("user_id IN (#{following_ids})
                    OR user_id = :user_id", user_id: id)
  end
end
