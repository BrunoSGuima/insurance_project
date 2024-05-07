module Types
  class PaymentInputType < Types::BaseInputObject
    argument :condition, String, required: true
    argument :payment_id, String, required: true
  end
end
