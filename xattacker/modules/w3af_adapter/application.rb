require 'thor'
require 'erb'
require 'tilt'
require 'nokogiri'
require 'active_support/core_ext/hash/conversions'
require 'securerandom'

require_relative '../../../lib/xlib'

Dir[File.expand_path('../strategies/*.rb', __FILE__)].each { |f| require f }
Dir[File.expand_path('../lib/*.rb', __FILE__)].each { |f| require f }

module XA
  module W3AFAdapter
    SEVERITY_LEVEL = {
      'low' => 3.0,
      'medium' => 6.0,
      'high' => 10.0
    }

    class Start < Thor
      option :session_id
      desc 'owasp_topten TARGETS', 'Perform OWASP Top 10 Attacking'
      def owasp_topten(targets_string)
        @targets = XSP::Targets.from_string(targets_string)

        @targets.targets_array.each do |target|
          AttackGraph::ActiveNode::Base.session_id = options[:session_id]
          host_node = AttackGraph::AttackNode.find(target)
          puts "before"
          puts host_node.addr
          puts host_node.addrtype
          puts "has HTTP" if host_node.has_service?(:http)
          # TODO: Move to .where semantics
          http_services = host_node.services.select do |service|
            service.service_name == 'http'
          end
          puts "after"

          http_services.each do |http_service_node|
            template = Tilt.new(File.expand_path('../templates/owasp_topten.w3af.erb', __FILE__))
            scope = Object.new
            auth = HttpBasicAuth.new(username: 'testUsername', password: 'testPassword')
            http_settings = HttpSettings.new
            session = "#{Time.now.to_i}_#{SecureRandom.hex(4)}"
            tmp = Tmp.new(session, File.expand_path('../tmp', __FILE__))
            scope.instance_variable_set(:@target, target)
            scope.instance_variable_set(:@auth, auth)
            scope.instance_variable_set(:@http_settings, http_settings)
            scope.instance_variable_set(:@tmp, tmp)
            script = template.render(scope)

            File.open(tmp.script_file_path, 'w') do |f|
              f.write script
            end

            puts "running w3af_console -s #{tmp.script_file_path}"
            `w3af_console -s #{tmp.script_file_path}`
            open_xml("#{tmp.output_file_path}.xml") do |oxml|
              extract_vulnerabilities(http_service_node, oxml)
            end
          end
        end
      end

      private

      def open_xml(output_file)
        File.open(output_file) { |f| yield Nokogiri::XML(f) }
      end

      def extract_vulnerabilities(service_node, oxml)
        vulnerabilities = oxml.xpath('//vulnerability')
        vulnerabilities.each do |vulnerability|
          service_node.vulnerabilities.create(name: vulnerability[:name],
                                              severity: SEVERITY_LEVEL[vulnerability[:severity].downcase],
                                              xmodule: 'w3af_adapter')
        end
      end
    end

    class Application < Thor
      desc 'start STRATEGY TARGETS', 'Start attacking on TARGETS with this STRATEGY'
      subcommand 'start', Start
    end
  end
end
