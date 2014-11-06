require_relative 'xservices/xscanner_client'

module XM
  class XScannerPhase < Phase
    client   XScannerClient
    register :nmap_adapter, :skipfish_adapter
  end
end
