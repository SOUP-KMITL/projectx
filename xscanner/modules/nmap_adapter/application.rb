require 'bundler/setup'

require 'thor'

require_relative 'strategies/default'
require_relative '../../../lib/xlib'

module XS
  module NmapAdapter
    class Start < Thor
      REGULAR_IPS_MATCH = /\A[^\s\-]\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}[^\/,-]\Z/

      attr_accessor :targets

      desc 'simple TARGETS', 'Start scanning on TARGETS'
      def simple(targets_string)
        @targets = []
        extract_ips(targets_string)
        puts "Scanning targets: #{@targets.inspect}"
        run_at_targets
      end

      private

      def run_at_targets(strategy = Strategies::Default)
        context = {}
        context[:tmp] = File.expand_path('../../../../tmp', __FILE__)

        @targets.each do |target|
          context[:target] = target
          run strategy, context
        end
      end

      def run(strategy, context)
        strategy.run(context)
      end

      def extract_ips(targets_string)
        targets_array = targets_string.split(',')
        targets_array.map!(&:strip)

        _extract_regular_ips(targets_array)
        _extract_ranged_ips(targets_array)
        _extract_subneted_ips(targets_array)
      end

      def _extract_regular_ips(targets_array)
        targets_array.each do |target|
          @targets << target if target.strip =~ REGULAR_IPS_MATCH
        end
      end

      def _extract_ranged_ips(targets)
      end

      def _extract_subneted_ips(targets)
      end
    end

    class Application < Thor
      desc 'start STRATEGY TARGETS', 'Start scanning on TARGETS with this STRATEGY'
      subcommand 'start', Start
    end
  end
end
