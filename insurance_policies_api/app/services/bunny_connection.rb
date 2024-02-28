require "bunny"
require_relative '../workers/policy_worker'

class BunnyConnection
  def self.connection
  conn = Bunny.new(host: 'rabbitmq', port: 5672, user: 'guest', password: 'guest')
  conn.start
  channel = conn.create_channel
  queue = channel.queue('policies')
  puts " [*] Waiting for messages. To exit press CTRL+C"

  consume(queue)
  end

  def self.consume(queue)
    queue.subscribe(block: true) do |delivery_info, properties, body|
      PolicyWorker.new.work(body)
    end
  ensure
    conn.close
  end
end

