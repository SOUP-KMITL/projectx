require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/json'

require_relative 'application'
require_relative 'xreporter_service'

module XR
  class XReporter < Sinatra::Base
    use Application
    use XReporterService
  end
end
