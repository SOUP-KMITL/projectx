module AttackGraph
  class ServiceNode < ActiveNode::Base
  end

  class AttackNode < ActiveNode::Base
    primary_key :addr
    base_path "/nodes"
    has_many :services, class: ServiceNode

    def has_service?(service_name)
      services.find do |service|
        service.service_name == service_name.to_s
      end
    end
  end
end
