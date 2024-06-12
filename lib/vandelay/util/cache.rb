module Vandelay
  module Util
    class Cache
      def initialize
        @redis = Redis.new(url: Vandelay.config.dig("persistence", "redis_url"))
      end

      def set(key, value, duration=600)
        @redis.set key, value
        @redis.expire key, duration
      end

      def get(key)
        @redis.get key
      end
    end
  end
end
