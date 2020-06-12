# frozen_string_literal: true

redis_url = ENV.fetch('SWAPP_REDIS_URL')
redis_connection = Redis.new(url: redis_url)

if redis_connection.ping == 'PONG'
  $swapp_namespace = Redis::Namespace.new(:swapp, redis: redis_connection)
  Rails.logger.info 'Successfully connected to Redis'
  puts '=== Successfully connected to Redis ==='
else
  Rails.logger.info 'Unable to connect to Redis'
  puts '=== Unable to connect to Redis ==='
end
