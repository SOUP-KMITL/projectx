ENV['RACK_ENV'] = 'test'

$:.unshift(File.expand_path('../', __FILE__))

require 'bundler/setup'
require 'rack/test'

require_relative '../xattack_graph'

def app
  XAttackGraph
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
