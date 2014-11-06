require_relative '../lib/xservice/xservice_server/base'
require_relative '../lib/xworkers'
require_relative 'app/workers/command_worker'

module XA
  class XAttackerService < XSV::XServiceServer::Base
    set :command_worker, CommandWorker
    Sidekiq.configure_client do |config|
      config.redis = { :namespace => 'xattacker', :size => 1 }
    end
  end
end
