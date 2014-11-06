module XA
  module HydraAdapter
    module Strategies
      class SimpleAttack
        attr_accessor :attack_options

        DEFAULT_TASKS = 16
        COMMENT_MATCH = /\A#/

        def initialize(options)
          @attack_options = {}
          @attack_options[:tasks]      = options[:tasks] || DEFAULT_TASKS
          @attack_options[:target]     = options[:target]
          @attack_options[:user_list]  = options[:user_list]
          @attack_options[:dictionary] = options[:dictionary]
          @attack_options[:output]     = options[:output]
        end

        def run
          @service_node = perform_checking
          if @service_node
            before_attack
            perform_attack
            after_attack
            process_result(@attack_options[:output])
          else
            # Log to XLogger
          end
        end

        def perform_checking
          attack_node = AttackGraph::AttackNode.find(@attack_options[:target])
          puts 'has attack_node' if attack_node
          attack_node && attack_node.has_service?(:ssh)
        end

        def perform_attack
          `hydra -L #{attack_options[:user_list]} -P #{attack_options[:dictionary]} -t #{attack_options[:tasks]} -o #{attack_options[:output]} #{attack_options[:target]} #{attack_options[:service]}`
        end

        def before_attack
        end

        def after_attack
        end

        def process_result(output_file)
          File.new(output_file).each do |line|
            unless line =~ COMMENT_MATCH
              puts line
              caps     = line.scan(/login:\s([^\s]*)\s+password:\s*([^\s]+)/)
              login    = caps[0][0]
              password = caps[0][1]
              @service_node.vulnerabilities.create(name: 'weak_password',
                                                   detail: "login: #{login}, password: #{password}")
            end
          end
        end
      end
    end
  end
end
