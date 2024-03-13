# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    user = User.from_omniauth(auth)

    if user.present?
      sign_out_all_scopes
      flash[:success] = 'Successfully signed in with Google.'
      jwt_token = create_jwt_for_user(user)
      cookies[:jwt_token] = {value: jwt_token, expires: 24.hours.from_now}
      puts "Token JWT definido no cookie: #{jwt_token}"
      puts "--------------------------------"
      sign_in_and_redirect user, event: :authentication
    else
      flash[:alert] = 
      'There was a problem signing in with Google. Please register or try signing in later.'
      redirect_to new_user_session_path
    end
  end

  private

  def auth
    @auth ||= request.env['omniauth.auth']
  end

  def create_jwt_for_user(user)
    payload = { user_id: user.id, email: user.email, exp: 24.hours.from_now.to_i }
    jwt_secret = 'secret_key'
    JWT.encode(payload, jwt_secret, 'HS256')
  end

end
