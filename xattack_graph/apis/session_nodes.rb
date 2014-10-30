module XAttackGraphAPI
  class SessionNodes < Sinatra::Base
    before do
      @neo = Neography::Rest.new
    end

    post '/sessions/?' do
      session_node_property = {
        created_at: Time.now.to_s,
        task: params[:task]
      }
      session_node = @neo.create_node(session_node_property)
      @neo.add_label(session_node, 'Session')
      session_node_property[:id] = session_node['self'].match(/data\/node\/(\d+)\Z/).captures.first.to_i

      json session_node_property
    end
  end
end
