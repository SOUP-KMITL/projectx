require_relative '../../../lib/xservice'

module XM
  class XScannerClient < XSV::XServiceClient::Base
    # TODO: Read from YAML
    base_uri 'localhost:3002'
  end
end
