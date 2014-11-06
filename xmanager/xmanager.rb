require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/json'

require_relative 'application'

module XM
  class XManager < Sinatra::Base
    use Application
  end
end
