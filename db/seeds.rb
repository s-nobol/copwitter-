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
              email: "#user_{n}@test.com",
              password: "password",
              activated: true )
end

users = User.order(:created_at).take(6)

15.times do |n|
  content = "適当な記事 番号#{n}"
  users.each { |user| user.posts.create!(content: content) }
end