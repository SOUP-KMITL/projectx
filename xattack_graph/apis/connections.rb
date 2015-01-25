module XAttackGraphAPI
  class ConnectionParamsError < StandardError; end

  class Connections < Sinatra::Base
    include AttackNodesHelper
    include ServiceNodesHelper

    before do
      @neo ||= Neography::Rest.new
    end

    # @!method get_connection
    get '/sessions/:session_id/nodes/:node_addr/connections/?' do
      src  = get_attack_node(params[:session_id], params[:node_addr])
      rels = @neo.get_node_relationships(src, 'out', 'connect_to')

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
    # @param addr [String] destination node
    # @param port_id [Number] destination service port
    # @param properties [Hash{Symbol => String, Number}]
    #   confidence: 0.0-1.0
    #   reason: String
    #   etc.
    # @return [String] HTTP status code indicate that creation is succeed or
    #   failed
    post '/sessions/:session_id/nodes/:node_addr/connections/?' do
      src  = get_attack_node(params[:session_id], params[:node_addr])
      dest = find_attack_or_service_node(params)

      rel  = @neo.create_relationship('connect_to', src, dest)
      @neo.set_relationship_properties(rel, params[:properties])

      200
    end

    private

    def find_attack_or_service_node(params={})
      addr    = params[:addr]
      port_id = params[:port_id]

      if port_id
        get_service_node(params[:session_id], addr, port_id)
      elsif addr
        get_attack_node(params[:session_id], addr)
      else
        raise ConnectionParamsError
      end
    end
  end
end
