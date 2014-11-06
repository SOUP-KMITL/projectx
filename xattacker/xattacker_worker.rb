require_relative '../lib/xworkers'
require_relative 'app/workers/command_worker'

module XS
  class XAttackerWorker < XW::XWorkers::Base
    namespace :xattacker
  end
end
