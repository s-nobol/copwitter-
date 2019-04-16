require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # ユーザーモデルテスト
  
  def setup
    @user = User.new(name: "fast_user",email: "fast_user@test.com",
                    password: "password", password_confirmation: "password")
  end
  
  test "user.valid?" do
    assert @user.valid? , "@user.save? = #{@user.save}"
  end
  
  test "name.empty?" do
    @user.name =""
    assert_not @user.valid? , "@user.save? = #{@user.save}"
  end
  
  test "emaii.empty?" do
    @user.email =""
    assert_not @user.valid? , "@user.save? = #{@user.save}"
  end
  
  test "password.empty?" do
    @user.password = @user.password_confirmation= ""
    assert_not @user.valid? , "@user.save? = #{@user.save} user_password#{@user.password_digest}"
  end
  
  test "name maximum 55" do
     @user.name ="a"*51
    assert_not @user.valid? , "@user.save? = #{@user.save}"
  end
  
  test "password minimum 6" do
    @user.password ="a"*5
    assert_not @user.valid? , "@user.save? = #{@user.save}"
  end
  
  # ユーザーユーザーステータステスト
  test "message > 256" do
    @user.message ="a"*257
    assert_not @user.valid? , "@user.save? = #{@user.save}"
  end
  test "address > 50" do
    @user.address ="a"*51
    assert_not @user.valid? , "@user.save? = #{@user.save}"
  end
  
  test "link > 250" do
    @user.link ="a"*257
    assert_not @user.valid? , "@user.save? = #{@user.save}"
  end
  
  test "barthday> 50" do
    @user.barthday ="a"*51
    assert_not @user.valid? , "@user.save? = #{@user.save}"
  end
end

# name: "123", email: "123@example.com", 
# image: nil,
# password_digest: "$2a$10$ESFDZLW0ABI9aaeqpzK7aeSI4oqEBy3UDVM2DVQTRxs...", 
# created_at: "2019-04-12 13:26:37", updated_at: "2019-04-14 17:46:17", 
# cookies_digest: "$2a$10$WN7HEgJi1vH9gK9cZ4YK4uaVquBzkq8G8BBTtKhWWOR...",
# activation_digest: nil, activated: true, reset_digest: "$2a$10$Z6MR7B3MWmM1.e.izz9QaODD9Uy4x5.NJbP4bc0MlKR...", 
# reset_sent_at: "2019-04-14 17:42:01", 
# background_image: nil, 
# message: nil, 
# address: nil, 
# link: nil, 
# barthday: nil> 