class PoliciesController < ApplicationController
  def show
    policy = Policy.find_by(policy_id: params[:id])
    render json: policy, include: ['insured', 'vehicle']
  end
end