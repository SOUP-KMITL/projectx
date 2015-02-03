require_relative '../../../lib/xservice'

module XM
  class XReporterClient < XSV::XServiceClient::Base
    settings = YAML.load_file(File.expand_path('../../../config.yml', __FILE__))['xreporter']
    base_uri "#{settings['host']}:#{settings['port']}"

    class << self
      def report(session_id, report_name)
        res = get("/sessions/#{session_id}/reports/#{report_name}")

        return unless res.ok?

        res
      end
    end
  end
end
