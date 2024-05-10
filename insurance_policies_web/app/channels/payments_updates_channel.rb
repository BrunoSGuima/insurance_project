class PaymentsUpdatesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "PaymentsUpdatesChannel"
    stream_for "PaymentsUpdatesChannel"
  end
end