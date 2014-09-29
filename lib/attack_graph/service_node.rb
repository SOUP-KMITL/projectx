require_relative 'node'

module AttackGraph
  class ServiceNode < Node
    attr_accessor :session_id, :properties
    attr_reader   :attack_node

    def initialize(session_id, attack_node, properties)
      @session_id  = session_id || 1234
      @attack_node = attack_node
      @properties  = properties
    end

    def vulnerabilities
    end

    def create_path
      "/sessions/#{@session_id}/nodes/#{attack_node_addr}/services"
    end

    def create_data
      @properties
    end

    def attack_node_addr
      @attack_node.addr
    end

    class << self
      def all(session_id, attack_node)
        get("/sessions/#{session_id}/nodes/#{attack_node_addr}/services")
      end

      def create(session_id, attack_node, properties)
        service_node = new(session_id, attack_node, properties)
        service_node.save
        service_node
      end
    end
  end
end
