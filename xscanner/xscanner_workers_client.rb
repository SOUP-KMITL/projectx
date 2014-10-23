require_relative '../lib/xlib'

module XS
  class XScannerWorkersClient < XW::XWorkersClient::Base
    # TODO: Read from YAML
    base_uri 'localhost:3002'
  end
end
