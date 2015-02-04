require 'thor'
require 'active_support'
require 'active_support/core_ext'
require 'active_model_serializers'
require 'fileutils'

require_relative '../../../lib/xlib'

require_relative 'serializers/vuln_node_serializer'
require_relative 'serializers/service_node_serializer'
require_relative 'serializers/attack_node_serializer'
require_relative 'serializers/all_in_one_serializer'

module XR
  module AllInOne
    class Start < Thor
      option :session_id
      option :root_dir
      desc 'json', 'Generating all-in-one JSON format'
      def json(output_file)
        poro = AllInOnePORO.new(options)
        serializer = AllInOneSerializer.new(poro)

        if options[:root_dir]
          FileUtils::mkdir_p(options[:root_dir]) unless Dir.exists?(options[:root_dir])
          output_file = "#{options[:root_dir]}/#{output_file}"
        end

        File.open(output_file, 'w') do |f|
          f.write serializer.as_json.to_json
        end
      end
    end

    class AllInOnePORO
      include ActiveModel::SerializerSupport

      def initialize(options)
        AttackGraph::ActiveNode::Base.session_id = options[:session_id]
      end

      def overall_score
        nodes_avg_severity = nodes.map(&:average_severity)
        nodes_avg_severity.reduce(:+) / nodes_avg_severity.size
      end

      def overall_description
        "banana banana banananaaa"
      end

      def nodes
        return @nodes if @nodes

        @nodes = AttackGraph::AttackNode.all
        @nodes.each do |attack_node|
          attack_node.extend ActiveModel::SerializerSupport
        end
      end
    end

    class Application < Thor
      desc 'start STRATEGY OUTPUT_FILE', 'Start generating OUTPUT_FILE report with this STRATEGY'
      subcommand 'start', Start
    end
  end
end
