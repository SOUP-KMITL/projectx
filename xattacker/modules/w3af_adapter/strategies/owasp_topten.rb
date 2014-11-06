module XA
  module W3AFAdapter
    module Strategies
      class OWASPTopten
        class << self
          attr_accessor :context

          def run(context)
            setup(context)
          end

          def setup(context)
            self.context = context
          end
        end
      end
    end
  end
end
