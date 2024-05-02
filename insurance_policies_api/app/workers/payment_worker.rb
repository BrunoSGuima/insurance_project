require "bunny"
require "json"

class PaymentWorker
  def initialize
    @conn = Bunny.new(host: 'rabbitmq', port: 5672, user: 'guest', password: 'guest')
    @conn.start
    @channel = @conn.create_channel
    @queue = @channel.queue('payments', durable: true)
  end

  def start
    puts " [*] Waiting for payment messages. To exit press CTRL+C"
    @queue.subscribe(block: true) do |delivery_info, properties, body|
      begin
        process_payment(body)
      rescue JSON::ParserError, ActiveRecord::RecordNotFound => e
        puts "Error processing payment: #{e.message}"
      rescue StandardError => e
        puts "Unexpected error: #{e.message}"
      end
    end
  end

  private

  def process_payment(body)
    data = JSON.parse(body, symbolize_names: true)
    ActiveRecord::Base.connection_pool.with_connection do
      policy = Policy.find_by(payment_id: data[:payment_id])
      raise "Policy not found" unless policy

      if policy.update(condition: data[:condition], payment_link: data[:payment_link])
        puts "Payment updated for policy ##{policy.id}"
      else
        puts "Failed to update payment for policy ##{policy.id}: #{policy.errors.full_messages.join(', ')}"
      end
    end
  end
end


#worker = PaymentWorker.new
#worker.start
