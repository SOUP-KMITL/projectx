require 'logger'
require_relative '../../lib/xlib'
require_relative 'phase'
require_relative 'xscanner_phase'
require_relative 'xattacker_phase'

module XM
  class TaskRunner
    attr_accessor :session_id, :task_file

    def initialize(task_file)
      @task_file  = task_file
      @session_id = AttackGraph::ActiveNode::Base.create_session(task: task_file)[:id]
    end

    def phases
      {
        :scanning  => XScannerPhase,
        :attacking => XAttackerPhase,
        :reporting => nil
      }
    end

    def phase(name, &block)
      to_run_phase = phases[name].new(@session_id)
      to_run_phase.instance_eval(&block)
      to_run_phase.run
    end

    def run
      instance_eval(File.read(@task_file), @task_file)
    end
  end
end
