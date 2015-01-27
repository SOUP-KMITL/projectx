require 'thor'

require_relative '../../../lib/xlib'

module XS
  module SInf
    class Start < Thor
      option :session_id
      desc 'app_db TARGETS', 'Start inferencing connections that look like applications and databases'
      def app_db(targets_string=nil)
        apps = []
        dbs  = []

        AttackGraph.with_session(options[:session_id]) do
          attack_nodes = AttackGraph::AttackNode.all

          attack_nodes.each do |a|
            if a.has_service?(:http)
              apps << a
            elsif a.has_service?(:mysql)
              dbs << { node_addr: a.addr, port_id: a.service(:mysql).port_id }
            end
          end

          apps.each do |a|
            dbs.each do |d|
              a.connect_to(addr: d[:node_addr], port_id: d[:port_id])
            end
          end
        end
      end
    end

    class Application < Thor
      desc 'start STRATEGY TARGETS', 'Start inferencing connections on TARGETS with this STRATEGY'
      subcommand 'start', Start
    end
  end
end
