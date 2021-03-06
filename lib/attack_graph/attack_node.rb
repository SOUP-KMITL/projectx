module AttackGraph
  class ServiceNode < ActiveNode::Base
  end

  class AttackNode < ActiveNode::Base
    primary_key :addr
    base_path '/nodes'
    has_many :services, class: ServiceNode

    def service(service_name)
      services.to_a.find do |service|
        service.service_name == service_name.to_s
      end
    end

    alias_method :has_service?, :service

    def vuln(vuln_name)
      vulnerabilities.to_a.find do |vuln|
        vuln.name == vuln_name.to_s if vuln.respond_to?(:name)
      end
    end

    alias_method :has_vuln?, :vuln

    def vulnerabilities
      # TODO: make this Association and can be flatten
      @vulnerabilities ||= services.map(&:vulnerabilities).map(&:to_a).flatten
    end

    def average_severity
      return 0.0 if vulnerabilities.empty?
      severities = vulnerabilities.map(&:severity).map(&:to_f)
      severities.reduce(:+) / severities.size
    end

    def connect_to(options={})
      self.class.post("#{base_singular_path}/connections/", body: options)
    end

    def connections
      self.class.get("#{base_singular_path}/connections/")
    end

    def reload
      # TODO: super
      @vulnerabilities = nil
    end
  end
end
