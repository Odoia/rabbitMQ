module SubscribeServices
  class SignUp
    require "bunny"
    require "dotenv/load"

    def call
      subscribe
    end

    private

    def subscribe
      connection = Bunny.new ENV['CLOUDAMQP_URL']
      connection.start  # Start a connection with the CloudAMQP server
      channel = connection.create_channel # Declare a channel
      queue = channel.queue("bunny_queue") # Declare a queue

      begin # Consume messages
        puts ' [*] Waiting for messages. To exit press CTRL+C'
        queue.subscribe(block: true) do |_delivery_info, _properties, body|
          puts "---------------------------"
          puts " [x] Delivery info: [#{_delivery_info}]"
          puts " [x] Properties: [#{_properties}]"
          puts " [x] Consumed message: [#{body}]"
          puts "---------------------------"
        end
      rescue Interrupt => _
        connection.close # Close the connection
        exit(0)
      end
    end
  end
end
