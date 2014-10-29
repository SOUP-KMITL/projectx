require_relative 'phase'
require_relative 'xscanner_phase'

module XM
  class TaskRunner
    def phases
      {
        :scanning  => XScannerPhase.new,
        :attacking => nil,
        :reporting => nil
      }
    end

    def phase(name, &block)
      phases[name].instance_eval(&block)
    end

    def run(task_file)
      instance_eval(File.read(task_file), task_file)
    end
  end
end
