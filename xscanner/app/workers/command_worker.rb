module XS
  class CommandWorker < XW::CommandWorker::Base
    def self.modules_path
      File.expand_path("../../../modules", __FILE__)
    end
  end
end
