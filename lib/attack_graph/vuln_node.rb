require 'httparty'
require_relative 'node'

module AttackGraph
  class VulnNode < Node
    attr_accessor :session_id, :properties
    attr_reader   :service_node

    def initialize(session_id, service_node, properties)
      @session_id   = session_id || 1234
      @service_node = service_node
      @properties   = properties
    end

    def create_path
      "/sessions/#{@session_id}/nodes/#{attack_node_addr}/services/#{service_node_id}/vulns"
    end

    def create_data
      @properties
    end

    def service_node_id
      @service_node.port_id
    end

    def attack_node_addr
      @service_node.attack_node_addr
    end

    class << self
      def all(session_id, attack_node)
        get("/sessions/#{session_id}/nodes/#{attack_node.addr}/services")
      end
    end
  end
end


