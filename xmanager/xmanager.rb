require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/json'

require_relative 'application'
require_relative 'scheduler'

module XM
  class XManager < Sinatra::Base
    use Application
    use Scheduler
  end
end
