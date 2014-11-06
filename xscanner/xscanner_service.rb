require_relative '../lib/xservice/xservice_server/base'
require_relative 'app/workers/command_worker'

module XS
  class XScannerService < XSV::XServiceServer::Base
    set :command_worker, CommandWorker
    Sidekiq.configure_client do |config|
      config.redis = { :namespace => 'xscanner', :size => 1 }
    end
  end
end
