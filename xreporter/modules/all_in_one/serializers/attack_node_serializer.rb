class AttackNodeSerializer < ActiveModel::Serializer
  self.root = false
  attributes :addr, :addrtype
  has_many :services, serializer: ServiceNodeSerializer

  def services
    object.services.map do |service_node|
      service_node.extend ActiveModel::SerializerSupport
    end
  end
end
