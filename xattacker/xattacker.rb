require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/json'

require_relative 'application'
require_relative 'xattacker_service'

module XA
  class XAttacker < Sinatra::Base
    use Application
    use XAttackerService
  end
end
