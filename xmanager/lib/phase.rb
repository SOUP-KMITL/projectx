require_relative 'command_builder'

module XM
  class Phase
    attr_accessor :xservice_client

    def initialize(session_id)
      @xservice_client = self.class.client_class.new(session_id: session_id)
    end

    def method_missing(m, *args, &block)
      xmodule_name = m.to_s
      if self.class.modules.include?(xmodule_name)
        CommandBuilder.new(xservice_client: xservice_client,
                           xmodule_name: xmodule_name)
      else
        super
      end
    end

    def run
      @xservice_client.run
    end

    def respond_to_missing?(m)
      if self.class.modules.include?(m.to_s)
        true
      else
        false
      end
    end

    class << self
      attr_accessor :modules, :client_class

      def register(*module_names)
        @modules ||= []
        module_names.each do |module_name|
          @modules << module_name.to_s
        end
      end

      def client(xservice_client_class)
        @client_class = xservice_client_class
      end
    end
  end
end
