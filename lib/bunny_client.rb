# frozen_string_literal: true

class BunnyClient
  class << self

    def connect!
      @conn = Bunny.new(ENV['CLOUDAMQP_URL'])
      @conn.start
      # create channel
      @channel = @conn.create_channel
      # starts fanout
      @fan_out = @channel.fanout('dio_users.out')
      @connected = true
    end

    # publish message
    def push(payload, type)
      connect! unless @connected
      @fan_out.publish(payload, { app_id: 'dio_users', type: type })

      true
    end
  end
end

