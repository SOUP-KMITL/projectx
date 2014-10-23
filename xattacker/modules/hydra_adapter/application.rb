require 'thor'

require_relative '../../../lib/xlib'

require_relative 'strategies/simple_attack'
Dir[File.expand_path('../strategies/*.rb', __FILE__)].each do |file|
  require file
end

module XA
  module HydraAdapter
    class Start < Thor
      desc '..', 'abc'
      def ssh(targets_string)
        @targets = XSP::Targets.from_string(targets_string)

        # FIXME: configurable from outside (options)
        attack_options = {}
        attack_options[:tasks]      = 4
        attack_options[:user_list]  = File.expand_path('../../../../tmp/user_list.txt', __FILE__)
        attack_options[:dictionary] = File.expand_path('../../../../tmp/dictionary.txt', __FILE__)
        attack_options[:output]     = File.expand_path("../../../../tmp/hydra_result_#{Time.now.to_i}.txt", __FILE__)
        @targets.targets_array.each do |target|
          attack_options[:target] = target
          run Strategies::SimpleSSH, attack_options
        end
      end

      desc '..', 'abc'
      def mysql(targets_string)
      end

      private

      def run(strategy, attack_options)
        strategy.new(attack_options).run
      end
    end

    class Application < Thor
      desc 'start STRATEGY TARGETS', 'Start attacking on TARGETS with this STRATEGY'
      subcommand 'start', Start
    end
  end
end
