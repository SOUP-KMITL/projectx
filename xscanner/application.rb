require 'pry'
require 'sidekiq'
require_relative 'app/workers/command_worker'

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
    set :modules_path, File.expand_path('../modules', __FILE__)

    get '/sessions/?' do
      sessions = []
      Session.command_queues.each do |session_id, command_queue|
        sessions << { session_id: session_id,
                      command_queue: command_queue }
      end
      json sessions
    end

    post '/sessions/?' do
      session_hash = {
        session_id: Session.next_session_id,
      }
      # puts `#{settings.modules_path}/nmap_adapter/nmap_adapter`
      json session_hash
    end

    post '/sessions/:session_id/commands/?' do
      Sidekiq.configure_client do |config|
        config.redis = { :namespace => 'x', :size => 1 }
      end
      command = params[:command]
      module_name = command.split(' ')[0]
      XS::CommandWorker.perform_async(module_name, command)
      command_queue = Session.command_queues[params[:session_id].to_i]
      command_queue << params[:command]
      json command_queue
    end
  end
end
