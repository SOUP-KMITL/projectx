module XAttackGraphAPI
  class AttackNodes < Sinatra::Base
    before do
      @neo = Neography::Rest.new
    end

    # INDEX
    get '/sessions/:session_id/nodes' do
      nodes = @neo.get_nodes_labeled('Host')
      nodes.map! { |node| node['data'] }
      json nodes
    end

    # SHOW
    get '/sessions/:session_id/nodes/:node_addr' do
      node = find_node(params)
      unless node.nil?
        json node['data']
      else
        400
      end
    end

    # CREATE
    post '/sessions/:session_id/nodes' do
      session_node    = @neo.get_node(params[:session_id])
      node_properties = params[:properties]
      node            = @neo.create_node(node_properties)
      @neo.add_label(node, 'Host')
      @neo.create_relationship('has_node', session_node, node)
      200
    end

    # UPDATE
    put '/sessions/:session_id/nodes/:node_addr' do
      updated_node_properties = params[:properties]
      node                    = find_node(params)
      @neo.set_node_properties(node, updated_node_properties)
      200
    end

    # DESTROY ALL
    delete '/sessions/:session_id/nodes' do
      # @neo.execute_query("match (n:Host) optional match (n)-[r]->(s) delete r, s")
      @neo.execute_query("match (s:Session)-[rr]->(n) where id(s) = #{params[:session_id]} optional match (n:Host)-[r]->(sv) delete n, rr, r, sv")
      200
    end

    # DESTROY
    delete '/sessions/:session_id/nodes/:node_addr' do
      # @neo.execute_query("match (n:Host { addr: '#{params[:node_addr]}' }) optional match (n)-[r]->(s) delete n, r, s")
      @neo.execute_query("match (s:Session)-[rr]->(n:Host { addr: '#{params[:node_addr]}' }) where id(s) = #{params[:session_id]} optional match (n)-[r]->(sv) delete n, rr, r, sv")
      200
    end

    private

    def find_node(params)
      @neo.find_nodes_labeled('Host', addr: params[:node_addr]).first
    end
  end
end
