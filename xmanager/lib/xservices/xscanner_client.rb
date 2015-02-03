require_relative '../../../lib/xservice'

module XM
  class XScannerClient < XSV::XServiceClient::Base
    settings = YAML.load_file(File.expand_path('../../../config.yml', __FILE__))['xscanner']
    base_uri "#{settings['host']}:#{settings['port']}"
  end
end
