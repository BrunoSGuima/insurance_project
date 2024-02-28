class PoliciesController < ApplicationController
  def show
    policy = Policy.find(policy_id: params[:id])
    render json: policy, include: ['insured', 'vehicle']
  end
end