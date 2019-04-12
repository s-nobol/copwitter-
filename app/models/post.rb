class Post < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :content ,presence: true, length: { maximum: 256}
  validates :user_id ,presence: true
  
  
  # いいねの記事を多い順でとってくる
  # def trend_feed
  #   @all_ranks = Note.find(Like.group(:note_id).order('count(note_id) desc').limit(3).pluck(:note_id)
  #   @post = Post.find(Like.group(:post_id).order('count(post_id) desc')).limit(5).pluck(:post_id) # ← 自作
  # end
end
