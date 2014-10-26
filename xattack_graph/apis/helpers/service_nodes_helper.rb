module ServiceNodesHelper
  def get_service_nodes(session_id, node_addr)
    query  = "MATCH (s:Session)-[:has_node]->(n:Host), (n:Host { addr: \"#{node_addr}\" })-[:has_service]->(sv) WHERE id(s) = #{session_id} RETURN sv"
    result = @neo.execute_query(query)

    result['data'].map do |data|
      data.first
    end
  end

  def get_service_node(session_id, node_addr, port_id)
    query  = "MATCH (s:Session)-[:has_node]->(n:Host), (n:Host { addr: \"#{node_addr}\" })-[:has_service]->(sv { port_id: \"#{port_id}\" }) WHERE id(s) = #{session_id} RETURN sv"
    result = @neo.execute_query(query)

    raise Sinatra::NotFound if result["data"].empty?

    result["data"].first.first
  end

  def create_service_node(session_id, node_addr, properties)
    node         = get_attack_node(session_id, node_addr)
    service_node = @neo.create_node(properties)
    @neo.add_label(service_node, 'Service')
    @neo.create_relationship('has_service', node, service_node)

    service_node
  end

  def update_service_node(session_id, node_addr, port_id, properties)
    service_node = get_service_node(session_id, node_addr, port_id)
    @neo.set_node_properties(service_node, properties)

    service_node
  end
end
