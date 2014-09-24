# Note:
# use -M option on multi-node attack
# Timeout-Retry strategy to assess the security of the system
# If it timeout and later retyings timeout too, maybe it has high protection
#
# I think it is not a good idea to having the strategy named Default
# it should be the proper named strategy and can append '(default)' to indicate it's a default

# single-node attack plan:
# 1. Collect all available service names from the target host
# 2. Run corresponding service attacking class such as ThcHydraAdapters::SSHAttack
#    for each collected service names that are in `AVAIL_SERVICES`
module XAttacker
  module ThcHydraAdapters
    class ThcHydraAdapter < AbstractAdapter
      AVAIL_SERVICES = [ :ssh, :ftp, :mysql ] # FIXME: it should load the list from somewhere

      attr_accessor :context

      def initialize(options)
        @neo                  = Neography::Rest.new
        self.context          = options[:context]
        self.context[:output] = "#{context[:tmp]}/hydra_report_#{Time.now.to_i}.txt"
      end

      def run
        host_node = get_host_node('192.168.56.102')
        ssh_service = get_ssh_service_node(host_node)
        vuln_node   = @neo.create_node(severity_level: 5, vuln_name: 'weak_password')
        @neo.add_label(vuln_node, 'Vulnerability')
        @neo.create_relationship('has_vulnerability', ssh_service, vuln_node)
        # ssh_attack = SSHAttack.new(context)
        # ssh_attack.run
      end

      def get_host_node(host_ip)
        @neo.find_nodes_labeled('Host', addr: host_ip).first
      end

      def get_ssh_service_node(host)
        has_service_rels = @neo.get_node_relationships(host, 'out', 'has_service')

        services = has_service_rels.map do |has_service_rel|
          @neo.get_node(has_service_rel["end"])
        end

        services.select do |service|
          service_properties = @neo.get_node_properties(service)
          service_properties["service_name"] == "ssh"
        end.first
      end
    end
  end
end
