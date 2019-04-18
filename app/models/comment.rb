class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :content , presence: true, length: { maximum: 256}
  # validates :user_id , presence: true
  # validates :post_id , presence: true
  # create_table :comments 
end
