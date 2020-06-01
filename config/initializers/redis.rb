# frozen_string_literal: true

redis_connection = Redis.new(url: ENV['SWAPP_REDIS_URL'])

if redis_connection.ping == 'PONG'
  $swapp_namespace = Redis::Namespace.new(:swapp, redis: redis_connection)
  Rails.logger.info 'Successfully connected to Redis'
else
  Rails.logger.info 'Unable to connect to Redis'
end