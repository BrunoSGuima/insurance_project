class PoliciesController < ApplicationController
  before_action :authenticate_request, only: [:index]


  def show
    policy = Policy.find_by(policy_id: params[:id])
    render json: policy, include: ['insured', 'vehicle']
  end

  def index
    policies = Policy.all
    render json: policies, include: ['insured', 'vehicle']
  end


  private

  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    begin

    decoded_token = JWT.decode(token, "secret_key", true, { algorithm: 'HS256' })
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end