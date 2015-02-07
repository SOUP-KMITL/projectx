require_relative 'xservices/xattacker_client'

module XM
  class XAttackerPhase < Phase
    client   XAttackerClient
    register :hydra_adapter, :w3af_adapter, :nikto_adapter
  end
end
