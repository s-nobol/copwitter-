require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
 
  test "account_activation" do
    @mail_user = users(:first_user)
    @mail_user.activation_token = @mail_user.create_token
    mail = UserMailer.activation(@mail_user).deliver_now
    assert_equal "Account activation", mail.subject,""
    assert_equal [@mail_user.email], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match @mail_user.name,               mail.body.encoded
    assert_match @mail_user.activation_token,   mail.body.encoded
    # assert_match CGI.escape(@mail_user.email),  mail.body.encoded
  end
  
  # メイラーの再テスト
  test "user_activation" do
    user = users(:first_user)
    user.activation_token = "d"
    mail = UserMailer.activation(user).deliver_now
    assert_equal [user.email], mail.to
  end

end
