module XAttackGraphAPI
  class SessionNodes < Sinatra::Base
    before do
      @neo = Neography::Rest.new
    end

    post '/sessions/?' do
      session_node_properties = {
        created_at: Time.now.to_s,
        task: params[:task],
        progress: 0
      }

      session_node = @neo.create_node(session_node_properties)
      @neo.add_label(session_node, 'Session')
      session_node_properties[:id] = session_node['self'].match(/data\/node\/(\d+)\Z/).captures.first.to_i

      json session_node_properties
    end

    get '/sessions/?' do
      # TODO
    end

    get '/sessions/:session_id' do
      session_node = @neo.get_node(params[:session_id])
      session_hash = @neo.get_node_properties(session_node).merge({
        id: params[:session_id]})

      json session_hash
    end

    put '/sessions/:session_id' do
      session_node = @neo.get_node(params[:session_id])
      @neo.set_node_properties(session_node, params[:properties])
      session_hash = @neo.get_node_properties(session_node).merge({
        id: params[:session_id]})

      json session_hash
    end
  end
end
