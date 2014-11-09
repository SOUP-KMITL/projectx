require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/json'

require_relative 'application'
require_relative 'xscanner_service'

module XS
  class XScanner < Sinatra::Base
    use Application
    use XScannerService
  end
end
