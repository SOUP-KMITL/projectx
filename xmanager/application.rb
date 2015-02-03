require 'sinatra/config_file'
require_relative '../lib/xlib'
require_relative 'app/workers/task_worker'
require_relative 'app/helpers/user_helper'

require_relative 'lib/xservices/xreporter_client'

Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'xmanager', :size => 1 }
end

module XM
  class Application < Sinatra::Base
    register Sinatra::ConfigFile

    helpers UserHelper

    config_file File.expand_path('../config.yml', __FILE__)

    post '/sessions/?' do
      session_hash = AttackGraph.create_session
      user = user_from_api_key(params[:api_key])
      TaskWorker.perform_async(params[:task], session_id: session_hash[:id],
                                              username: user['username'])

      json session_hash
    end

    get '/sessions/?' do
      # TODO:
    end

    get '/sessions/:session_id/?' do
      # TODO:
    end

    post '/signin/?' do
      api_key = authenticate(params[:username], params[:password])

      if api_key
        json({ api_key: api_key })
      else
        401
      end
    end

    get '/tasks/?' do
      user = user_from_api_key(params[:api_key])

      json Dir[File.expand_path("users/#{user['username']}/tasks/*.rb")]
    end

    get '/sessions/:session_id/reports/?' do
      # TODO
      # proxy to xreporter /sessions/:session_id/reports
      # check access permission
      json [ 'test.html', 'tmp_file3.json' ]
    end

    get '/sessions/:session_id/reports/:report_name/?' do
      # TODO
      # proxy to xreporter /sessions/:session_id/reports/:report_name
      # check access permission
      json XReporterClient.report(params[:session_id], params[:report_name])
    end
  end
end
