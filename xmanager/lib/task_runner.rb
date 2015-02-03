require 'logger'
require_relative '../../lib/xlib'
require_relative 'phase'
require_relative 'xscanner_phase'
require_relative 'xattacker_phase'
require_relative 'xreporter_phase'

module XM
  class TaskRunner
    attr_accessor :session_id, :task_file

    def initialize(task_file, options={})
      @task_file  = task_file
      @session_id = options['session_id'] || AttackGraph.create_session(task: task_file)[:id]
      @logger     = ::Logger.new(STDOUT)
    rescue AttackGraph::SessionError
      puts "Could not create a new session"
      exit
    end

    def phases
      {
        :scanning  => XScannerPhase,
        :attacking => XAttackerPhase,
        :reporting => XReporterPhase
      }
    end

    def phase(name, &block)
      @logger.info "Entering #{name} phase"
      to_run_phase = phases[name].new(@session_id)
      to_run_phase.instance_eval(&block)
      @logger.info "Connecting to xservice server"
      to_run_phase.run
    rescue Errno::ECONNREFUSED
      @logger.fatal "Could not connect to xservice server"
      exit
    end

    def update_progress(progress)
      AttackGraph.with_session(@session_id) do
        AttackGraph::update_session({ progress: progress })
      end
    end

    def run
      instance_eval(File.read(@task_file), @task_file)
    end
  end
end
