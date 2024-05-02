module Mutations
  class UpdatePaymentMutation < Mutations::BaseMutation
    argument :payment_data, Types::PaymentInputType, required: true

    field :status, String, null: false

    def resolve(payment_data:)
      conn = Bunny.new(hostname: 'rabbitmq', username: 'guest', password: 'guest').start
      ch = conn.create_channel
      queue = ch.queue('payments', durable: true)
      queue.publish(payment_data.to_json)

      {'status' => 'OK'}
    rescue StandardError => e
      raise GraphQL::ExecutionError, e.message
    end
  end
end
