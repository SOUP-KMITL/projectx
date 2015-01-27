require 'sidekiq'
require_relative '../../lib/task_runner'

module XM
  class TaskWorker
    include Sidekiq::Worker

    def perform(task_name, options={})
      TaskRunner.new(task_path(task_name), options).run
    end

    def task_path(task_name)
      File.expand_path("../../../tasks/#{task_name}.rb", __FILE__)
    end
  end
end

