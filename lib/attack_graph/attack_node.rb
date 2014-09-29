module AttackGraph
  class ServiceNode < ActiveNode::Base
  end

  class AttackNode < ActiveNode::Base
    primary_key :addr
    base_path "/nodes"
    has_many :services, class: ServiceNode
  end
end
