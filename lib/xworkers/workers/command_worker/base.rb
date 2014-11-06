module XW
  module CommandWorker
    class Base
      include Sidekiq::Worker

      def self.modules_path
        raise NotImplementedError
      end

      def perform(command)
        module_name = command.split(' ')[0]
        module_path = "#{self.class.modules_path}/#{module_name}"
        command     = "#{module_path}/#{command}"
        system("#{command}")
      end
    end
  end
end
