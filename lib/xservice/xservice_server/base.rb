module XSV
  module XServiceServer
    # Must set command_worker
    class Base < Sinatra::Base
      post '/sessions/:session_id/?' do
        session_hash = {
          session_id: params[:session_id],
          commands: params[:commands]
        }

        session_hash[:commands].each do |command|
          command << ' --session_id '
          command << session_hash[:session_id]
          settings.command_worker.perform_async(command)
        end

        json session_hash
      end
    end
  end
end
