require 'httparty'

module XW
  # Expect that subclass will call base_uri()
  module XWorkersClient
    class Base
      include HTTParty

      def create_session
        self.class.post("/sessions")
      end

      def commands(session_id)
        self.class.get("/sessions/#{session_id}/commands")
      end

      def add_command(session_id, command)
        self.class.post("/sessions/#{session_id}/commands", body:
                        { command: command })
      end
    end
  end
end
