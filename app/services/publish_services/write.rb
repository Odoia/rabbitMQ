module PublishServices
  class Write
    require "bunny"
    require "dotenv/load"

    def initialize(message:)
      @msg = message
    end

    def call
      publish
    end

    private

    attr_reader :msg

    def publish
      connection = Bunny.new ENV['CLOUDAMQP_URL']
      connection.start # Start a connection with the CloudAMQP server
      channel = connection.create_channel # Declare a channel
      queue = channel.queue("bunny_queue") # Declare a queue

      # Declare a default direct exchange which is bound to all queues
      exchange = channel.exchange("")

      # Publish a message to the exchange which then gets routed to the queue
      exchange.publish(msg, :key => queue.name)

      connection.close # Finally, close the connection
    end
  end
end
