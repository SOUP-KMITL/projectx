module XAttacker
  module ThcHydraAdapters
    class SSHAttack < CommonAttack
      def initialize(options)
        super
        @attack_options[:service] = :ssh
      end

      def before_attack
        puts 'starting thc_hydra: ssh_attacker'
      end

      def after_attack
        puts 'ended thc_hydra: ssh_attacker'
      end
    end
  end
end
