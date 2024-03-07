class PagesController < ApplicationController
  def home
    @policies = GraphqlService.get_policies if current_user
  end
end
