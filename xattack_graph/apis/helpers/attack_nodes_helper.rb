class AttackNodeOperationFailureError < StandardError; end

module AttackNodesHelper
  def get_attack_nodes(session_id)
    query = "MATCH (s:Session)-[:has_node]->(n:Host) WHERE id(s) = #{session_id} RETURN n"
    puts "Query = #{query}"
    result = @neo.execute_query("MATCH (s:Session)-[:has_node]->(n:Host) WHERE id(s) = #{session_id} RETURN n")

    result["data"].map do |data|
      data.first
    end
  end

  def get_attack_node(session_id, node_addr)
    result = @neo.execute_query("MATCH (s:Session)-[:has_node]->(n:Host { addr: \"#{node_addr}\" }) WHERE id(s) = #{session_id} RETURN n")
    # TODO: should raise other thing because it is also used by other methods
    raise Sinatra::NotFound if result["data"].empty?

    result["data"].first.first
  end

  def create_attack_node(session_id, properties)
    session_node = get_session_node(session_id)
    node         = @neo.create_node(properties)
    @neo.add_label(node, 'Host')
    @neo.create_relationship('has_node', session_node, node)

    true
  end

  def update_attack_node(session_id, node_addr, properties)
    node = get_attack_node(session_id, node_addr)
    @neo.set_node_properties(node, properties)

    true
  end

  def destroy_attack_node(session_id, node_addr)
    @neo.execute_query("match (s:Session)-[rr]->(n:Host { addr: '#{node_addr}' }) where id(s) = #{session_id} optional match (n)-[r]->(sv) delete n, rr, r, sv")

    true
  rescue Neography::OperationFailureException
    raise AttackNodeOperationFailureError
  end

  def destroy_all_attack_nodes(session_id)
    @neo.execute_query("match (s:Session)-[rr]->(n) where id(s) = #{session_id} optional match (n:Host)-[r]->(sv) delete n, rr, r, sv")

    true
  rescue Neography::OperationFailureException
    raise AttackNodeOperationFailureError
  end
end
