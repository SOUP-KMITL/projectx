require_relative 'task_runner'

task_file  = File.expand_path('../../tasks/web.rb', __FILE__)
# task_file  = File.expand_path('../../tasks/simple.rb', __FILE__)

XM::TaskRunner.new(task_file).run
