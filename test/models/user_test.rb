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
     @user.name ="a"*56
    assert_not @user.valid? , "@user.save? = #{@user.save}"
  end
  
  test "password minimum 6" do
    @user.password ="a"*5
    assert_not @user.valid? , "@user.save? = #{@user.save}"
  end
end
