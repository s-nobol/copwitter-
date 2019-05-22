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
  
  # メールの検証
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
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

