module XA
  module W3AFAdapter
    class Tmp
      attr_accessor :session, :path, :output_path

      def initialize(session, path)
        @session = session
        @path = path
        @output_path = "#{@path}/output"
      end

      def script_file_path
        "#{@path}/w3af_script_#{@session}.w3af"
      end

      def output_file_path
        "#{@path}/output/w3af_output_#{@session}"
      end
    end
  end
end
