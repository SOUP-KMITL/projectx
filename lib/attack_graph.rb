require_relative 'attack_graph/active_node/base'
require_relative 'attack_graph/active_node/association'
require_relative 'attack_graph/attack_node'
require_relative 'attack_graph/service_node'
require_relative 'attack_graph/vuln_node'

module AttackGraph
  class << self
    def with_session(session_id)
      old_session_id = ActiveNode::Base.session_id
      ActiveNode::Base.session_id = session_id
      result = yield
      ActiveNode::Base.session_id = old_session_id
      result
    end

    def all_sessions
      ActiveNode::Base.all_sessions
    end

    def create_session
      ActiveNode::Base.create_session
    end

    def update_session(properties={})
      ActiveNode::Base.update_session(properties)
    end

    def session_properties
      ActiveNode::Base.session_properties
    end
  end
end
