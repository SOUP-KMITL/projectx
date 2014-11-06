require 'logger'
require 'httparty'

module XSV
  module XServiceClient
    class Base
      include HTTParty
      # logger ::Logger.new(STDOUT)

      attr_accessor :session_id

      def initialize(options={})
        @session_id = options[:session_id]
      end

      def run
        result = self.class.post("/sessions/#{@session_id}", body: { commands: @commands })
        if result.ok?
          puts result
        else
          raise "Could not create a new session for some reasons"
        end

        reload
      end

      def commands
        @commands ||= get_commands
      end

      def add_command(command)
        @commands ||= []
        @commands << command
      end

      def get_commands
        self.class.get("/sessions/#{@session_id}/commands")
      end

      def reload
        @commands   = nil
      end
    end
  end
end
