require_relative '../lib/xlib'
require_relative 'app/workers/task_worker'

Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'xmanager', :size => 1 }
end

module XM
  class Application < Sinatra::Base
    post '/sessions/?' do
      session_hash = AttackGraph.create_session
      TaskWorker.perform_async(params[:task], session_id: session_hash[:id])

      json session_hash
    end
  end
end
