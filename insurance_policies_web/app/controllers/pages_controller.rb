class PagesController < ApplicationController

  def home
    if current_user
      jwt_token = cookies[:jwt_token]
      puts '--------------------------------'
      puts "JWT Token: #{jwt_token.inspect}"
      puts '--------------------------------'
      if jwt_token.present?
        @policies = GraphqlService.get_policies(jwt_token)
      else
        puts "JWT Token is missing."
        @policies = []
      end
    end
  end
  
end
