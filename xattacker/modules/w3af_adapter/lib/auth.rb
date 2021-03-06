module XA
  module W3AFAdapter
    class Auth
      attr_accessor :username, :password

      def initialize(options)
        @username = options[:username]
        @password = options[:password]
      end

      def http_basic?
        false
      end

      def detailed?
        false
      end

      def ntlm?
        false
      end
    end

    class HttpBasicAuth < Auth
      def http_basic?
        true
      end
    end
  end
end
