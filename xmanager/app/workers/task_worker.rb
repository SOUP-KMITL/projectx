require_relative '../../lib/task_runner'

module XM
  class TaskWorker
    include Sidekiq::Worker

    def perform(task_name)
      TaskRunner.new(task_path(task_name)).run
    end

    def task_path(task_name)
      File.expand_path('../../../tasks', __FILE__)
    end
  end
end

