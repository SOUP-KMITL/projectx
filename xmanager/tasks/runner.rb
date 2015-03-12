require_relative '../../web_client/lib/xclient'

namespace :runner do
  task :start, [:api_key, :task_name] do |t, args|
    puts "Starting task: #{args.task_name}"

    xclient = XClient.new(base_uri: 'localhost:4001',
                          api_key: args.api_key) # FIXME
    xclient.create_session(task: args.task_name)

    puts "Ended"
  end
end
