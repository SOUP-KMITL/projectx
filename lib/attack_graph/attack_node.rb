module AttackGraph
  class ServiceNode < ActiveNode::Base
  end

  class AttackNode < ActiveNode::Base
    primary_key :addr
    base_path '/nodes'
    has_many :services, class: ServiceNode

    def has_service?(service_name)
      services.to_a.find do |service|
        service.service_name == service_name.to_s
      end
    end

    def vulnerabilities
      # TODO: make this Association and can be flatten
      @vulnerabilities ||= services.map(&:vulnerabilities).map(&:to_a).flatten
    end

    def average_severity
      severities = vulnerabilities.map(&:severity).map(&:to_f)
      severities.reduce(:+) / severities.size
    end

    def reload
      # TODO: super
      @vulnerabilities = nil
    end
  end
end
