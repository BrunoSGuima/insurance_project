# frozen_string_literal: true

class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  ENDPOINT_SECRET = Rails.application.credentials.dig(:stripe, :secret_webhook)

  def update
  payload = request.body.read
  sig_header = request.env['HTTP_STRIPE_SIGNATURE']

  begin
    event = Stripe::Webhook.construct_event(
      payload, sig_header, ENDPOINT_SECRET
    )

    if event.type == 'checkout.session.completed'
      session = event.data.object
      @payment_id = session.id
      @payment_condition = session.status
      send_request(payment_update)
    else
      puts "Unhandled event type: #{event.type}"
    end
    rescue Stripe::SignatureVerificationError => e
      render json: { message: 'Signature verification failed' }, status: 400
      return
    rescue => e
      render json: { message: 'Error processing webhook' }, status: 400
      return
    end
  end

  def payment_update
    {
      query: "mutation updatePaymentMutation(
        $payment_id: String!
        $condition: String!
      ) {
        updatePayment (
          input: {
            paymentData:{
              paymentId: $payment_id
              condition: $condition
            }
          }
        ) { status }
      }",
      variables: {
        payment_id: @payment_id,
        condition: 'paid'
      }
    }
  end

  def send_request(payment_update)
    url = URI('http://localhost:5000/graphql')
    header = {'Content-Type': 'application/json'}
    Net::HTTP.post(url, payment_update.to_json, header)
  end
end
