class AttackNodeSerializer < ActiveModel::Serializer
  self.root = false
  attributes :addr, :addrtype
  has_many :services, serializer: ServiceNodeSerializer
  has_many :connections

  def addrtype
    object.addrtype if object.respond_to?(:addrtype)
  end

  def services
    object.services.map do |service_node|
      service_node.extend ActiveModel::SerializerSupport
    end
  end

  def connections
    conns = {}

    object.connections.each do |c|
      addr = c['node']
      if conns[addr]
        conns[addr][:confidence] += c['confidence'].to_f
        conns[addr][:reasons] << { service: c['service'], confidence: c['confidence'].to_f, reason: c['reason'] }
      else
        puts c
        conns[addr] = {
          confidence: c['confidence'].to_f,
          reasons: [ { service: c['service'], confidence: c['confidence'].to_f, reason: c['reason'] } ]
        }
      end
    end

    conns_arr = []
    
    conns.each do |addr, conn|
      conns_arr << conn.merge({ node: addr })
    end

    conns_arr
  end
end
