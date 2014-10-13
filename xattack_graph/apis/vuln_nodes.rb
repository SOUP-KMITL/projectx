module XAttackGraphAPI
  class VulnNodes < Sinatra::Base
    before do
      @neo = Neography::Rest.new
    end

    get '/sessions/:session_id/nodes/:node_addr/services/:service_port_id/vulns' do
      service       = find_service(params[:node_addr], params[:service_port_id])
      has_vuln_rels = @neo.get_node_relationships(service, 'out', 'has_vulnerability')

      vulns = has_vuln_rels.map do |has_vuln_rel|
        vuln_node = @neo.get_node(has_vuln_rel['end'])
        vuln      = vuln_node['data']
        vuln[:id] = vuln_node['self'].match(/data\/node\/(\d+)\Z/).captures.first
        vuln
      end

      json vulns
    end

    post '/sessions/:session_id/nodes/:node_addr/services/:service_port_id/vulns' do
      service_node    = find_service(params[:node_addr], params[:service_port_id])
      vuln_properties = params[:properties]
      vuln_node       = @neo.create_node(vuln_properties)
      @neo.add_label(vuln_node, 'Vulnerability')
      @neo.create_relationship('has_vulnerability', service_node, vuln_node)

      reloaded_properties       = @neo.get_node_properties(vuln_node)
      reloaded_properties[:id]  = vuln_node['self'].match(/data\/node\/(\d+)\Z/).captures.first
      json reloaded_properties
    end

    get '/sessions/:session_id/nodes/:node_addr/services/:service_port_id/vulns/:vuln_id' do
      vuln = find_vuln(params[:node_addr], params[:service_port_id], params[:vuln_id])

      if vuln
        json vuln
      else
        400
      end
    end

    put '/sessions/:session_id/nodes/:node_addr/services/:service_port_id/vulns/:vuln_id' do
      # TODO:
    end

    delete '/sessions/:session_id/nodes/:node_addr/services/:service_port_id/vulns/:vuln_id' do
      # TODO:
    end

    private

    def find_service(node_addr, service_port_id)
      node             = @neo.find_nodes_labeled('Host', addr: params[:node_addr])
      has_service_rels = @neo.get_node_relationships(node, 'out', 'has_service')

      services = has_service_rels.map do |has_service_rel|
        @neo.get_node(has_service_rel['end'])
      end

      services.select do |s|
        service_properties = @neo.get_node_properties(s)
        service_properties['port_id'] == params[:service_port_id]
      end.first
    end

    def service_vulns(node_addr, service_port_id)
      service_node = find_service(node_addr, service_port_id)

      return nil if service_node.nil?

      has_vuln_rels = @neo.get_node_relationships(service_node, 'out', 'has_vulnerability')

      has_vuln_rels.map do |has_vuln_rel|
        vuln_node = @neo.get_node(has_vuln_rel['end'])
        vuln      = vuln_node['data']
        vuln[:id] = vuln_node['self'].match(/data\/node\/(\d+)\Z/).captures.first
        vuln
      end
    end

    def find_vuln(node_addr, service_port_id, vuln_id)
      vuln_nodes = service_vulns(node_addr, service_port_id)
      vuln_nodes.find { |vuln_node| vuln_node[:id] == vuln_id }
    end
  end
end

