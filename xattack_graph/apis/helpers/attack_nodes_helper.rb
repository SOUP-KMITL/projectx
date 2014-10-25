class AttackNodeNotFoundError < StandardError; end

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

    raise AttackNodeNotFoundError if result["data"].empty?

    result["data"].first.first
  end
end
