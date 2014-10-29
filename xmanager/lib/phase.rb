require_relative 'command_builder'

module XM
  class Phase
    def method_missing(m, *args, &block)
      xmodule_name = m.to_s
      if self.class.modules.include?(xmodule_name)
        puts "\tabout to run #{m}"
        CommandBuilder.new(xmodule_name)
      else
        super
      end
    end

    def respond_to_missing?(m)
      if self.class.modules.include?(m.to_s)
        true
      else
        false
      end
    end

    class << self
      attr_accessor :modules

      def register(*module_names)
        @modules ||= []
        module_names.each do |module_name|
          @modules << module_name.to_s
        end
      end
    end
  end
end
