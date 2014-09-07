require 'nokogiri'
require 'active_support/core_ext/hash/conversions'
require 'neography'

module NmapAdapters
  module Strategies

    class Default
      class << self
        attr_accessor :context, :host_nodes

        def run(context)
          puts 'starting...'
          setup(context)
          perform_discovery
          perform_scan
          puts 'ended'
        end

        def setup(context)
          self.context    = context
          self.host_nodes = []
          @neo = Neography::Rest.new
        end

        def perform_discovery
          discover(self.context[:target])
        end

        def perform_scan
          host_nodes.each { |host_node| scan(host_node) }
        end

        def discover(target)
          output_file = "#{context[:tmp]}/nmap_scan_#{Time.now.to_i}.xml"
          `nmap -sP #{target} -oX #{output_file} --no-stylesheet`

          open_xml(output_file) { |oxml| extract_host(oxml) }
        end

        def scan(host_node)
          output_file = "#{context[:tmp]}/nmap_scan_#{Time.now.to_i}.xml"
          `nmap -PN #{@neo.get_node_properties(host_node)['addr']} -oX #{output_file} --no-stylesheet`

          open_xml(output_file) { |oxml| extract_services_for(host_node, oxml) }
        end

        def extract_host(oxml)
          host      = oxml.xpath('//host')
          host_hash = Hash.from_xml(host.to_s)

          host_attr = {
            addr: host_hash['host']['address']['addr'],
            addrtype: host_hash['host']['address']['addrtype'],
            state: host_hash['host']['status']['state']
          }
          host_node = @neo.create_node(host_attr)
          @neo.add_label(host_node, 'Host')
          host_nodes << host_node
        end

        def extract_services_for(host_node, oxml)
          services = oxml.xpath('//port')
          services.each do |service|
            service_hash = Hash.from_xml(service.to_s)['port']
            service_attr = {
              protocol: service_hash['protocol'],
              port_id: service_hash['portid'],
              state: service_hash['state']['state'],
              service_name: service_hash['service']['name'],
              conf: service_hash['service']['conf']
            }
            service_node = @neo.create_node(service_attr)
            @neo.create_relationship('has_service', host_node, service_node)
          end
        end

        def open_xml(output_file)
          File.open(output_file) { |f| yield Nokogiri::XML(f) }
        end
      end
    end

  end
end
