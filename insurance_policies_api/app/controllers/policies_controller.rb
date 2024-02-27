class PoliciesController < ApplicationController
  def show
    policy = Policy.find(params[:id])
    render json: policy, include: ['insured', 'vehicle']
  end
end