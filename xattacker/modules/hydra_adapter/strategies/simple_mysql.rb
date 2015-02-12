module XA
  module HydraAdapter
    module Strategies
      class SimpleMySQL < SimpleAttack
        def initialize(opitons)
          super
          @attack_options[:service] = :mysql
        end

        def before_attack
          puts 'starting thc_hydra: mysql'
        end

        def after_attack
          puts 'ended thc_hydra: mysql'
        end
      end
    end
  end
end
