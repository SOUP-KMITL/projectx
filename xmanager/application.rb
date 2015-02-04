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
      return 401 if params[:api_key].nil? || params[:api_key].empty?

      api_key = params[:api_key]

      sessions = AttackGraph.all_sessions
      sessions.select! { |s| s['api_key'] == api_key }

      json sessions
    end

    get '/sessions/:session_id/?' do
      session_properties = nil
      AttackGraph.with_session(params[:session_id]) do
        session_properties = AttackGraph.session_properties
      end

      json session_properties
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
