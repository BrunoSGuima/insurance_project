class PaymentsController < ApplicationController
  def success
    flash[:notice] = "Compra bem sucedida!"
    redirect_to root_path
  end
  
  def cancel
    flash[:alert] = "Falha no processo de compra."
    redirect_to root_path
  end

  def confirm
    ActionCable.server.broadcast("PaymentUpdatesChannel", params.to_json)
  end
end
