module XS
  class CommandWorker
    include Sidekiq::Worker

    def perform(module_name, command)
      module_path = File.expand_path("../../../modules/#{module_name}", __FILE__)
      command = "#{module_path}/#{command}"
      `BUNDLE_GEMFILE=#{module_path}/Gemfile bundle exec #{command}`
    end
  end
end
