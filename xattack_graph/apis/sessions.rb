module XAttackGraphAPI
  class Sessions < Sinatra::Base
    before do
      @neo = Neography::Rest.new
    end

    post '/sessions/?' do
      session_node = @neo.create_node(created_at: Time.now.to_s)
      @neo.add_label(session_node, 'Session')
      session_node_property      = @neo.get_node_properties(session_node)
      session_node_property[:id] = session_node['self'].match(/data\/node\/(\d+)\Z/).captures.first

      json session_node_property
    end
  end
end
