require_relative '../lib/xlib'
require_relative 'app/workers/task_worker'

Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'xscanner', :size => 1 }
end

module XM
  class Application < Sinatra::Base
    post '/sessions/?' do
      # session_hash = AttackGraph::ActiveNode::Base.create_session(params)

      # json session_hash
      #
      # TODO:
      # The web here should be the one who create the session and
      # response the created session id to user
      TaskWorker.perform_async(params[:task])
      200
    end
  end
end
