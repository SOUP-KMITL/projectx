require_relative '../lib/xworkers'
require_relative 'app/workers/command_worker'

module XR
  class XReporterWorker < XW::XWorkers::Base
    namespace :xreporter
  end
end
