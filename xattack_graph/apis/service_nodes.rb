module XAttackGraphAPI
  class ServiceNodes < Sinatra::Base
    before do
      @neo = Neography::Rest.new
    end

    get '/sessions/:session_id/nodes/:node_addr/services' do
      node             = @neo.find_nodes_labeled('Host', addr: params[:node_addr])
      has_service_rels = @neo.get_node_relationships(node, 'out', 'has_service')

      services = has_service_rels.map do |has_service_rel|
        @neo.get_node(has_service_rel['end'])['data']
      end

      json services
    end

    post '/sessions/:session_id/nodes/:node_addr/services' do
      node               = @neo.find_nodes_labeled('Host', addr: params[:node_addr])
      service_properties = { protocol: params[:protocol],
                             service_name: params[:service_name],
                             port_id: params[:port_id],
                             conf: params[:conf],
                             state: params[:state] }
      service            = @neo.create_node(service_properties)
      @neo.add_label(service, 'Service')
      @neo.create_relationship('has_service', node, service)

      200
    end

    get '/sessions/:session_id/nodes/:node_addr/services/:service_port_id' do
      node = @neo.find_nodes_labeled('Host', addr: params[:node_addr])

      has_service_rels = @neo.get_node_relationships(node, 'out', 'has_service')

      services = has_service_rels.map do |has_service_rel|
        @neo.get_node(has_service_rel['end'])
      end

      service = services.select do |s|
        service_properties = @neo.get_node_properties(s)
        service_properties['port_id'] == params[:service_port_id]
      end.first['data']

      json service
    end
  end
end
