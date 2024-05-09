class PaymentsUpdatesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "PaymentsUpdatesChannel"
    stream_for "PaymentsUpdatesChannel"
  end

  def receive
    ActionCable.server.broadcast "PaymentsUpdatesChannel", "Payment received"
  end
end