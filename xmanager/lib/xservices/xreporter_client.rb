require_relative '../../../lib/xservice'

module XM
  class XReporterClient < XSV::XServiceClient::Base
    # TODO: Read from YAML
    base_uri 'localhost:3004'

    class << self
      def report(session_id, report_name)
        res = get("/sessions/#{session_id}/reports/#{report_name}")

        return unless res.ok?

        res
      end
    end
  end
end
