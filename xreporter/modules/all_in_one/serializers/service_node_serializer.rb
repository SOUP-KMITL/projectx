class ServiceNodeSerializer < ActiveModel::Serializer
  self.root = false
  attributes :name, :port, :software
  has_many :vulnerabilities, serializer: VulnNodeSerializer

  def name
    object.service_name
  end

  def port
    object.port_id
  end

  def software
    "somesoftware 3.1.2"
  end

  def vulnerabilities
    object.vulnerabilities.map do |vuln_node|
      vuln_node.extend ActiveModel::SerializerSupport
    end
  end
end
