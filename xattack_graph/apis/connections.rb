module XAttackGraphAPI
  class ConnectionPatternError < StandardError; end

  class Connections < Sinatra::Base
    include AttackNodesHelper
    include ServiceNodesHelper

    before do
      @neo ||= Neography::Rest.new
    end

    # @params src  NODE[addr] | NODE[addr]SERVICE[port]
    get '/sessions/:session_id/connections/?' do
      # TODO return both incoming and outgoing connections to src
    end

    # @params src  NODE[addr] | NODE[addr]SERVICE[port]
    # @params dest NODE[addr] | NODE[addr]SERVICE[port]
    # @params properties Hash
    #           confidence 0.0-1.0
    #           description String
    #           etc.
    post '/sessions/:session_id/connections/?' do
      src  = find_attack_or_service_node(params[:session_id], params[:src])
      dest = find_attack_or_service_node(params[:session_id], params[:dest])

      rel  = @neo.create_relationship('connect', src, dest)
      @neo.set_relationship_properties(rel, params[:properties])

      200
    end

    private

    def find_attack_or_service_node(session_id, pattern)
      if (m = pattern.match(/NODE\[([^\]]*)\]SERVICE\[([^\]]*)\]/))
        addr    = m[1]
        port_id = m[2]

        get_service_node(session_id, addr, port_id)
      elsif (m = pattern.match(/NODE\[([^\]]*)\]/))
        addr    = m[1]

        get_attack_node(session_id, addr)
      else
        raise ConnectionPatternError
      end
    end
  end
end
