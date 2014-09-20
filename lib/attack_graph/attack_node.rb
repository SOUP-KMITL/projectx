require_relative 'node'

module AttackGraph
  class AttackNode < Node
    attr_accessor :session_id, :properties

    def initialize(session_id, properties)
      @session_id = session_id || 1234
      @properties = properties
    end

    def services
    end

    def vulnerabilities
    end

    def create_path
      "/sessions/#{@session_id}/nodes"
    end

    def create_data
      @properties
    end

    def update_path
    end

    def update_data
    end

    def destroy_path
    end

    class << self
      def all(session_id)
        get("/sessions/#{session_id}/nodes")
      end

      def create(session_id, properties)
        attack_node = new(session_id, properties)
        attack_node.save
        attack_node
      end
    end
  end
end
