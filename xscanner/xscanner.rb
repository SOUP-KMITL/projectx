require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/json'

require_relative 'application'

module XS
  class XScanner < Sinatra::Base
    use Application
  end
end
