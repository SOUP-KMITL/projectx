module XAttackGraphAPI
  class ConnectionPatternError < StandardError; end

  class Connections < Sinatra::Base
    include AttackNodesHelper
    include ServiceNodesHelper

    before do
      @neo ||= Neography::Rest.new
    end

    # @!method get_connection
    # @param src  [String] string of pattern:
    #   `"NODE[addr]" or "NODE[addr]SERVICE[port]"`
    get '/sessions/:session_id/connections/:src/?' do
      src  = find_attack_or_service_node(params[:session_id], params[:src])
      rels = @neo.get_node_relationships(src, 'out', 'connect')

      rels.map! do |rel|
        end_node = @neo.get_node(rel['end'])
        service  = nil

        if @neo.get_node_labels(end_node).include?('Service')
          has_service_rel = @neo.get_node_relationships(end_node, 'in', 'has_service').first
          service         = end_node['data']['service_name']
          end_node        = @neo.get_node(has_service_rel['start'])
        end

        {
          node: end_node['data']['addr'],
          service: service,
        }.merge!(rel['data'])
      end

      json rels
    end

    # @!method post_connections
    # @param src  [String] string of pattern:
    #   `"NODE[addr]" or "NODE[addr]SERVICE[port]"`
    # @param dest [String] string of pattern:
    #   `"NODE[addr]" or "NODE[addr]SERVICE[port]"`
    # @param properties [Hash{Symbol => String, Number}]
    #   confidence: 0.0-1.0
    #   description: String
    #   etc.
    # @return [String] HTTP status code indicate that creation is succeed or
    #   failed
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
