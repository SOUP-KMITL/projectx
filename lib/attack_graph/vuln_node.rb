module AttackGraph
  class VulnNode < ActiveNode::Base
    primary_key :id
    base_path "/vulns"
  end
end

