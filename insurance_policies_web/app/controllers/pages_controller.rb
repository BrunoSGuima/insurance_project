class PagesController < ApplicationController

  def home
    if current_user
      jwt_token = cookies[:jwt_token]
      if jwt_token.present?
        @policies = GraphqlService.get_policies(jwt_token)
      else
        puts "JWT Token is missing."
        @policies = []
      end
    end
  end

  def new
  end

  def create
    jwt_token = cookies[:jwt_token] || session[:jwt_token]
    input = {
      policyId: params[:policyId],
      issueDate: params[:issueDate],
      coverageEndDate: params[:coverageEndDate],
      insuredName: params[:insuredName],
      insuredItin: params[:insuredItin],
      vehicleCarBrand: params[:vehicleCarBrand],
      vehicleModel: params[:vehicleModel],
      vehicleYear: params[:vehicleYear],
      vehiclePlateNumber: params[:vehiclePlateNumber]
    }
    response = GraphqlService.create_policy(jwt_token, input)
    if response["status"] == "OK"
      redirect_to root_path, notice: "Apólice criada com sucesso!"
    else
      render :new, alert: "Erro ao criar apólice."
    end
    puts "AQUI: --------------------------------------"
    Rails.logger.info("Input to GraphQL: #{input}")
    puts "--------------------------------------"

  end

  private

  def policy_params
    params.require(:policy).permit(:policy_id, :issue_date, :coverage_end_date, :insured_name, :insured_itin, :vehicle_car_brand, :vehicle_model, :vehicle_year, :vehicle_plate_number)
  end
  
end
  
