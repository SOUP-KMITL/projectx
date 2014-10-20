require_relative 'app/workers/command_worker'

Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'x' }
end
