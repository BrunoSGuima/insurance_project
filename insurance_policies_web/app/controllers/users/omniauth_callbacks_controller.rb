# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    user = User.from_omniauth(auth)

    if user.present?
      sign_out_all_scopes
      flash[:success] = 'Successfully signed in with Google.'
      set_jwt_cookie_for(user)
      sign_in_and_redirect user, event: :authentication
    else
      flash[:alert] = 
      'There was a problem signing in with Google. Please register or try signing in later.'
      redirect_to new_user_session_path
    end
  end

  def cognito_idp
    user = User.from_omniauth(auth)

    if user.persisted?
      flash[:success] = "Successfully authenticated from Cognito account."
      set_jwt_cookie_for(user)
      sign_in_and_redirect user, event: :authentication
    else
      flash[:alert] = "Authentication via Cognito failed."
      redirect_to new_user_session_path
    end

  end

  private

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end
