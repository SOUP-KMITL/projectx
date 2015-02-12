require 'ipaddr'

module XSP
  class Targets
    REGULAR_IPS_MATCH = /\A[^\s\-]\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}[^\/,-]*\Z/

    attr_accessor :targets_array

    def initialize(targets_array)
      @targets_array = targets_array
    end

    class << self
      def from_string(targets_string)
        targets_array = _extract_ips(targets_string)

        new(targets_array)
      end

      private

      def _extract_ips(targets_string)
        targets_array = targets_string.split(',')
        targets_array.map!(&:strip)

        targets_array = _extract_regular_ips(targets_array)
        targets_array = _extract_ranged_ips(targets_array)
        targets_array = _extract_subneted_ips(targets_array)

        targets_array
      end

      def _extract_regular_ips(targets_array)
        targets_array
      end

      def _extract_ranged_ips(targets_array)
        targets_array
      end

      def _extract_subneted_ips(targets_array)
        holder = []

        targets_array.each do |target|
          holder += IPAddr.new(target).to_range.to_a.map(&:to_s)
        end

        holder
      end
    end
  end
end
