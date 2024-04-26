module Mutations
  class UpdatePaymentMutation < Mutations::BaseMutation
    argument :payment_data, Types::PaymentInputType, required: true

    field :success, String, null: false

    def resolve(payment_data:)
      puts "Received payment data: #{payment_data.inspect}"

      # Publica na fila RabbitMQ
      conn = Bunny.new(hostname: 'rabbitmq', username: 'guest', password: 'guest').start
      ch = conn.create_channel
      queue = ch.queue('payments', durable: true)
      queue.publish(payment_data.to_json)
      #conn.close

      {'success' => 'OK'}
    rescue StandardError => e
      raise GraphQL::ExecutionError, e.message
    end
  end
end
