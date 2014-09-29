require 'httparty'

module AttackGraph
  module ActiveNode
    class Base
      include HTTParty
      # FIXME:
      base_uri 'localhost:9292'
      FAKE_SID = 1234
      @@session_id  = FAKE_SID

      attr_reader :properties

      def initialize(properties = {})
        @belongs_tos        = []
        @properties         = properties
      end

      def save
        if persisted?
          self.class.put(base_singular_path, body: { properties: @properties })
        else
          self.class.post(base_collection_path, body: { properties: @properties })
        end
      end

      def update_properties(properties)
        self.class.put(base_singular_path, body: @properties.merge(properties))
      end

      def destroy
        self.class.delete(base_singular_path)
      end

      def method_missing(m, *args, &block)
        @properties[m.to_sym] || super
      end

      def persisted?
        @persisted ||= self.class.get(base_singular_path)[self.class.primary_key.to_s]
      end

      def belongs_to(active_node)
        @belongs_tos << active_node
      end

      def base_singular_path
        "#{base_collection_path}/#{@properties[self.class.primary_key]}"
      end

      def base_collection_path
        if @belongs_tos.any?
          "#{@belongs_tos.first.base_singular_path}#{self.class.base_path}"
        else
          "/sessions/#{@@session_id}#{self.class.base_path}"
        end
      end

      class << self
        def create(properties = {})
          active_node = new(properties)
          active_node.save
          active_node
        end

        def all
          node_array.map! do |node|
            new(node['data'])
          end
        end

        def find
        end

        def where
        end

        def clear
        end

        def base_path(path=nil)
          return @base_path if path.nil?
          @base_path = path
        end

        def primary_key(key=nil)
          return @primary_key if key.nil?
          @primary_key = key
        end

        def has_many(collection, options)
          collection_path = options[:collection_path] || collection.to_s
          define_method(collection) do
            instance_collection_path = "#{base_singular_path}/#{collection_path}"
            Association.new(options[:class], instance_collection_path, self)
          end
        end
      end
    end
  end
end
