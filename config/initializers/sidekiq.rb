require "sidekiq"

Sidekiq.configure_client do |config|
  if Rails.env.development?
    config.redis = { port: 16399 }
  else
    config.redis = { port: 6379 }
  end
end

Sidekiq.configure_server do |config|
  if Rails.env.development?
    config.redis = { port: 16399 }
  else
    config.redis = { port: 6379 }
  end
end
