# frozen_string_literal: true

redis_connection = Redis.new(url: ENV['HERMPORIO_REDIS_URL'])

if redis_connection.ping == 'PONG'
  $hermporio_namespace = Redis::Namespace.new(:hermporio, redis: redis_connection)
  Rails.logger.info 'Successfully connected to Redis'
else
  Rails.logger.info 'Unable to connect to Redis'
end