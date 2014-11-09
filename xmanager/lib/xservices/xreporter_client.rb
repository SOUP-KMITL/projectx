require_relative '../../../lib/xservice'

module XM
  class XReporterClient < XSV::XServiceClient::Base
    # TODO: Read from YAML
    base_uri 'localhost:3004'
  end
end
