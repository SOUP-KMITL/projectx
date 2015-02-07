require_relative '../lib/xservice/xservice_server/base'
require_relative '../lib/xworkers'
require_relative 'app/workers/command_worker'

module XR
  class XReporterService < XSV::XServiceServer::Base
    set :command_worker, CommandWorker

    Sidekiq.configure_client do |config|
      config.redis = { :namespace => 'xreporter', :size => 1 }
    end

    get '/sessions/:session_id/reports/?' do
      # TODO
    end

    get '/sessions/:session_id/reports/:report_name/?' do
      json JSON.parse(File.read(File.expand_path("../reports/#{params[:session_id]}/#{params[:report_name]}", __FILE__)))
    end

    def add_default_options(command, session_hash)
      command << ' --root_dir '
      command << File.expand_path("../reports/#{session_hash[:session_id]}", __FILE__)
      super
    end
  end
end
