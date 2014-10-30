require_relative '../lib/xworkers'
require_relative 'app/workers/command_worker'

Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'xscanner', :size => 1 }
end

module XS
  class Session
    # TODO: Make this persist
    class << self
      attr_accessor :latest_session_id, :command_queues

      def next_session_id
        @command_queues    ||= {}
        @latest_session_id ||= 0
        @latest_session_id += 1
        @command_queues[@latest_session_id] = []

        @latest_session_id
      end
    end
  end

  class Application < Sinatra::Base
    # set :modules_path, File.expand_path('../modules', __FILE__)

    get '/sessions/:session_id/?' do
      sessions = []
      Session.command_queues.each do |session_id, command_queue|
        sessions << { session_id: session_id,
                      command_queue: command_queue }
      end
      json sessions
    end

    post '/sessions/:session_id/?' do
      session_hash = {
        session_id: params[:session_id],
        commands: params[:commands]
      }
      session_hash[:commands].each do |command|
        command << ' --session_id'
        command << session_hash[:session_id]
        XS::CommandWorker.perform_async(command)
      end

      json session_hash
    end

    # post '/sessions/:session_id/commands/?' do
    #   command = params[:command]
    #   module_name = command.split(' ')[0]
    #   XS::CommandWorker.perform_async(module_name, command)
    #   command_queue = Session.command_queues[params[:session_id].to_i]
    #   command_queue << params[:command]
    #   json command_queue
    # end
  end
end
