require_relative 'attack_graph/active_node/base'
require_relative 'attack_graph/active_node/association'
require_relative 'attack_graph/attack_node'
require_relative 'attack_graph/service_node'
require_relative 'attack_graph/vuln_node'

module AttackGraph
  def self.with_session(session_id)
    old_session_id = ActiveNode::Base.session_id
    ActiveNode::Base.session_id = session_id
    result = yield
    ActiveNode::Base.session_id = old_session_id
    result
  end

  def self.create_session
    ActiveNode::Base.create_session
  end
end
