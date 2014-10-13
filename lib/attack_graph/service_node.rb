module AttackGraph
  class VulnNode < ActiveNode::Base
  end

  class ServiceNode < ActiveNode::Base
    primary_key :port_id
    base_path "/services"
    has_many :vulnerabilities, class: VulnNode
  end
end
