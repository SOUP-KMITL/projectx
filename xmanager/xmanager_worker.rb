require_relative '../lib/xworkers'
require_relative 'app/workers/task_worker'

module XM
  class XManagerWorker < XW::XWorkers::Base
    namespace :xworker
  end
end
