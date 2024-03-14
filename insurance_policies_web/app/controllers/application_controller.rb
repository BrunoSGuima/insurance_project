class ApplicationController < ActionController::Base
  
  def set_jwt_cookie_for(user)
    jwt_token = create_jwt_for_user(user)
    cookies[:jwt_token] = { value: jwt_token, expires: 24.hours.from_now }
    puts "Token JWT definido no cookie: #{jwt_token}"
      puts "--------------------------------"
  end

  def create_jwt_for_user(user)
    payload = { user_id: user.id, email: user.email, exp: 24.hours.from_now.to_i }
    jwt_secret = 'secret_key'
    JWT.encode(payload, jwt_secret, 'HS256')
  end


end
