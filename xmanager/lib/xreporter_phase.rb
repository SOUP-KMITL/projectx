require_relative 'xservices/xreporter_client'

module XM
  class XReporterPhase < Phase
    client   XReporterClient
    register :all_in_one
  end
end
