module XAttackGraphAPI
  class AttackNodes < Sinatra::Base
    before do
      @neo = Neography::Rest.new
    end

    get '/sessions/:session_id/nodes' do
      nodes = @neo.get_nodes_labeled('Host')

      nodes.map! do |node|
        node['data']
      end

      json nodes
    end

    post '/sessions/:session_id/nodes' do
      node_properties = { addrtype: params[:addrtype],
                          addr: params[:addr],
                          state: params[:state] }
      node = @neo.create_node(node_properties)
      @neo.add_label(node, 'Host')

      200
    end

    get '/sessions/:session_id/nodes/:node_addr' do
      node = @neo.find_nodes_labeled('Host', addr: params[:node_addr]).first['data']

      json node
    end

    put '/sessions/:session_id/nodes/:node_addr' do
      # TODO:
    end

    delete '/sessions/:session_id/nodes/:node_addr' do
      # TODO:
    end
  end
end
