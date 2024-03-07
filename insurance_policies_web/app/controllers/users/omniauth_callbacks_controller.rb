# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  def google_oauth2
    user = User.from_omniauth(auth)

    if user.present?
      sign_out_all_scopes
      flash[:success] = 'Successfully signed in with Google.'
      sign_in_and_redirect user, event: :authentication
      jwt_token = create_jwt_for_user(user)
    else
      flash[:alert] = 
      'There was a problem signing in with Google. Please register or try signing in later.'
      redirect_to new_user_session_path
    end
  end

  # protected

  # def after_omniauth_failure_path_for(_scope)
  #   new_user_session_path
  # end

  # def after_sign_in_path_for(resource_or_scope)
  #   stored_location_for(resource_or_scope) || root_path
  # end

  private

  def auth
    @auth ||= request.env['omniauth.auth']
  end

  def create_jwt_for_user(user)
    payload = { user_id: user.id, email: user.email, exp: 24.hours.from_now.to_i }
    jwt_secret = 'chave_secreta'
    token = JWT.encode(payload, jwt_secret, 'HS256')
    token
  end


  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end