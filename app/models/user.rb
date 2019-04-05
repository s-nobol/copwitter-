class User < ApplicationRecord
  
  validates :name ,presence: true, length: { maximum: 55 }
  validates :email ,presence: true
  
  has_secure_password
  validates :password, presence: true, length: { minimum: 5 }
end
