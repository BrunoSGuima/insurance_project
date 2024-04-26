class PoliciesController < ApplicationController
  #Atualizar depois aqui
  before_action :authenticate_request, only: [:index]
  before_action :set_policy, only: [:show]

  def index
    policies = Policy.all
    render json: policies, include: ['insured', 'vehicle']
  end
  
  def show
    render json: @policy, include: ['insured', 'vehicle']
  end


  private

  def set_policy
    @policy = Policy.find_by(policy_id: params[:id])
    render json: { error: 'Policy not found' }, status: :not_found unless @policy
  end

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