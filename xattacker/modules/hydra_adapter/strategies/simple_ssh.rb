module XA
  module HydraAdapter
    module Strategies
      class SimpleSSH < SimpleAttack
        def initialize(opitons)
          super
          @attack_options[:service] = :ssh
        end

        def before_attack
          puts 'starting thc_hydra: ssh'
        end

        def after_attack
          puts 'ended thc_hydra: ssh'
        end
      end
    end
  end
end
