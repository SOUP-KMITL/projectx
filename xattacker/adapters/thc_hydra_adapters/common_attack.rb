require 'neography'

module XAttacker
  module ThcHydraAdapters
    class CommonAttack
      attr_accessor :attack_options

      DEFAULT_TASKS = 16

      def initialize(options)
        @attack_options = {}
        @attack_options[:tasks]      = options[:tasks] || DEFAULT_TASKS
        @attack_options[:target]     = options[:target]
        @attack_options[:user_list]  = options[:user_list]
        @attack_options[:dictionary] = options[:dictionary]
        @attack_options[:output]     = options[:output]
      end

      def run
        before_attack
        perform_attack
        after_attack
      end

      def perform_attack
        `hydra -L #{attack_options[:user_list]} -P #{attack_options[:dictionary]} -t #{attack_options[:tasks]} -o #{attack_options[:output]} #{attack_options[:target]} #{attack_options[:service]}`
      end

      def before_attack
      end

      def after_attack
      end

      def process_result

      end
    end
  end
end
