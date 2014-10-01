module AttackGraph
  module ActiveNode
    class Association
      include HTTParty
      include Enumerable
      base_uri 'localhost:9292' # FIXME:

      attr_accessor :active_node_class

      def initialize(active_node_class, collection_path, parent_node)
        @active_node_class = active_node_class
        @collection_path   = collection_path
        @collection        = []
        @parent_node       = parent_node
      end

      def each(&block)
        to_a.each(&block)
      end

      def build
      end

      def singular_path(id)
        "#{collection_path}/#{id}"
      end

      def collection_path
        "#{@parent_node.base_singular_path}#{@active_node_class.base_path}"
      end

      def create(properties)
        self.class.post(collection_path, body: { properties: properties })
        active_node = active_node_class.new(properties)
        active_node.belongs_to(@parent_node)
        active_node
      end

      def count
        to_a.count
      end

      def clear
        self.class.delete(collection_path)
      end

      def find(id)
        response = self.class.get(singular_path(id))

        if response.code == 200
          node_hash = response.to_h
          active_node_class.new(node_hash)
        else
          nil
        end
      end

      def reload
        @collection = []
        self
      end

      def empty?
        to_a.empty?
      end

      def to_a
        if @collection.any?
          @collection
        else
          @collection = self.class.get(collection_path)
          @collection.map! do |node|
            active_node = active_node_class.new(node)
            active_node.belongs_to(@parent_node)
            active_node
          end
        end
      end
    end
  end
end
