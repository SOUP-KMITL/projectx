require_relative '../lib/xworkers'
require_relative 'app/workers/command_worker'

module XS
  class XScannerWorkers < XW::XWorkers::Base
    namespace :xscanner
  end
end
