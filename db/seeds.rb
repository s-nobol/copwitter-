# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#UserにStatusを付けないとエラーに
User.create(name: "123", 
            email: "123@example.com",
            password: "123123",
            activated: true )

15.times do |n|
  User.create(name: "#{n}_user", 
              email: "#user_#{n}@test.com",
              password: "password",
              activated: true )
end

users = User.order(:created_at).take(6)

15.times do |n|
  content = "これはテスト記事です　カウント#{n}回"
  users.each { |user| user.posts.create!(content: content) }
end

# フォロワーの作成
users = User.all
user  = users.first
following = users[2..10]
followers = users[3..10]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }


# コメント（5個）

5.times do |n|
  posts = Post.all.take(5-n)
  posts.each do |post|
      users[n].comments.create!(content: "テストコメント#{n}", post: post)
      users[n].likes.create!(post: post)
  end
end
  
