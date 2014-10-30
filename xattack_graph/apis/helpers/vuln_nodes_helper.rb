module VulnNodesHelper
  def get_vuln_nodes(session_id, node_addr, port_id)
    query  = "MATCH (s:Session)-[:has_node]->(n:Host { addr: \"#{node_addr}\" })-[:has_service]->(sv:Service { port_id: \"#{port_id}\" })-[:has_vulnerability]->(v) WHERE id(s) = #{session_id} RETURN v"
    result = @neo.execute_query(query)

    result['data'].map do |data|
      data.first
    end
  end

  def get_vuln_node(session_id, node_addr, port_id, vuln_id)
    query  = "MATCH (s:Session)-[:has_node]->(n:Host { addr: \"#{node_addr}\" })-[:has_service]->(sv:Service { port_id: \"#{port_id}\" })-[:has_vulnerability]->(v) WHERE id(s) = #{session_id} AND id(v) = #{vuln_id} RETURN v"

    result = @neo.execute_query(query)

    raise Sinatra::NotFound if result["data"].empty?

    result["data"].first.first
  end

  def create_vuln_node(session_id, node_addr, port_id, properties)
    service_node = get_service_node(session_id, node_addr, port_id)
    vuln_node    = @neo.create_node(properties)
    @neo.add_label(vuln_node, 'Vulnerability')
    @neo.create_relationship('has_vulnerability', service_node, vuln_node)

    vuln_node
  end
end
