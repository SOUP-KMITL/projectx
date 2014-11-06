require_relative '../../../lib/xservice'

module XM
  class XAttackerClient < XSV::XServiceClient::Base
    # TODO: Read from YAML
    base_uri 'localhost:3003'
  end
end
