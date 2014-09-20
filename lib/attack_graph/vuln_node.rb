require 'httparty'
require_relative 'node'

module AttackGraph
  class VulnNode < Node
    include HTTParty
    base_uri 'localhost:9292' # FIXME

    attr_accessor :session_id, :properties

    def initialize(session_id, node_id, service_port_id, properties)
      @session_id = session_id || 1234
      @node_id    = node_id
      @service_port_id = service_port_id
      @properties = properties
    end

    def save
      self.class.post("/sessions/#{@session_id}/nodes/#{@node_id}/services/#{service_port_id}", body: @properties)
    end

    def destroy
    end

    def method_missing
      # TODO: search in @properties
    end

    class << self
      def all(session_id, node_id)
        get("/sessions/#{session_id}/nodes/#{node_id}/services")
      end
    end
  end
end


