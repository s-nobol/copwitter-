ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

include SessionsHelper

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  # テストユーザーがログイン中の場合にtrueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end
end


class ActionDispatch::IntegrationTest

  # テストユーザーとしてログインする
  def login_as(user, password: 'password')
    post login_path, params: { session: { email: user.email,
                                          password: password } }
  end
end