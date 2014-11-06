module XW
  module XWorkers
    class Base
      def self.namespace(ns)
        Sidekiq.configure_server do |config|
          config.redis = { :namespace => ns }
        end
      end
    end
  end
end
