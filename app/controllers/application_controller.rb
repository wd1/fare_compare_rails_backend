class ApplicationController < ActionController::API
  before_action :authorized

  def issue_token(user)
    JWT.encode({user_id: user.id}, ENV['secret_key_base'], 'HS256')
  end

  def current_user
    @user ||= User.find_by(id: user_id)
  end

  def token
    request.headers['Authorization']
  end

  def decoded_token
    begin
      # [{user_id: 1}, {algo: 'hs256'}]
      JWT.decode(token, ENV['secret_key_base'], true, { :algorithm => 'HS256' })
    rescue JWT::DecodeError
      [{}]
    end
  end

  def user_id
    decoded_token.first['user_id']
  end

  def authorized
    render json: {message: "Not welcome" }, status: 401 unless logged_in?
  end

  def logged_in?
    !!current_user
  end
end
