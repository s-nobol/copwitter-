# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/activation
  def activation
    user = User.first
    user.activation_token = user.create_token
    UserMailer.activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.activation_token = User.create_token
    UserMailer.password_reset(user)
  end

end