require 'sidekiq'
require_relative '../../lib/task_runner'

module XM
  class TaskWorker
    include Sidekiq::Worker

    def perform(task_name, options={})
      username  = options.delete('username')
      task_path = task_path(username, task_name)
      TaskRunner.new(task_path, options).run
    end

    def task_path(username, task_name)
        File.expand_path("../../../users/#{username}/tasks/#{task_name}.rb",
                         __FILE__)
    end
  end
end

