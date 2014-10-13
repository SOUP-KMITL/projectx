require 'httparty'

module AttackGraph
  class Node
    include HTTParty
    base_uri 'localhost:9292' # FIXME

    def save
      # TODO: check exising
      self.class.post(create_path, body: create_data)
      # self.class.put(create_path)
    end

    def destroy
      self.class.delete(destroy_path)
    end

    def create_path
      raise NotImplementedError
    end

    def create_data
      raise NotImplementedError
    end

    def update_path
      raise NotImplementedError
    end

    def update_data
    end

    def destroy_path
      raise NotImplementedError
    end

    def method_missing(m, *args, &block)
      @properties[m.to_sym] || super
    end
  end
end
