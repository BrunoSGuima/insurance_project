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
      puts "Policies aqui: -----------------------------------------"
      puts @policies
      puts "Policies aqui: -----------------------------------------"
    end
  end

  def new
  end

  def create
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price: 'price_1P8jIuF0XqjltaBhSHMlnuli',
        quantity: 1,
      }],
      mode: 'payment',
      success_url: payments_success_url,
      cancel_url: payments_cancel_url
    )

    input = prepare_input(session)

    response = GraphqlService.create_policy(cookies[:jwt_token] || session[:jwt_token], input)

    if response["status"] == "OK"
      redirect_to root_path, notice: "Apólice criada com sucesso!"
    else
      render :new, alert: "Erro ao criar apólice: #{response['errors'] || 'Unknown error'}"
    end
  end


  private

  def prepare_input(session)
    {
    policyId: params[:policyId],
    issueDate: params[:issueDate],
    coverageEndDate: params[:coverageEndDate],
    insuredName: params[:insuredName],
    insuredItin: params[:insuredItin],
    vehicleCarBrand: params[:vehicleCarBrand],
    vehicleModel: params[:vehicleModel],
    vehicleYear: params[:vehicleYear],
    vehiclePlateNumber: params[:vehiclePlateNumber],
    paymentId: session.id,
    paymentLink: session.url
    }
  end
  
end
  
