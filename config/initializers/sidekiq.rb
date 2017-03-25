require "sidekiq"

Sidekiq.configure_client do |config|
  config.redis = { :size => 1, port: 16399 }
end

Sidekiq.configure_server do |config|
  config.redis = { :size => 2, port: 16399}
end
