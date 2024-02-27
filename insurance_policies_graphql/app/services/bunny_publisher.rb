class BunnyPublisher

  def initialize
    @connection = Bunny.new(host:'rabbitmq', port: '5672').start
    @channel = @connection.create_channel
    puts "PUTS FORA DO RESCUE"
  rescue StandardError => e
    Rails.logger.error { "\n\n \e[41m [ERROR] \e[0m RabbitMQ Publisher connection falied: #{e.message}\n\n" }
    puts "\n\n \e[41m [ERROR] \e[0m RabbitMQ Publisher connection falied: #{e.message}\n\n"
    @connection.close if @connection.present?
  end


  def publish(data:, queue:)
    puts "CHAMANDO PUBLISH"
    return unless @connection && @channel

    queue = @channel.queue(queue)
    queue.publish(data)
    puts data.to_json
    Rails.logger.info "\e[42m [SUCCESS] \e[0m RabbitMQ Publisher published successfully"
    @connection.close
  end
end
