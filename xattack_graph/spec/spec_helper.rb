ENV['RACK_ENV'] = 'test'

$:.unshift(File.expand_path('../', __FILE__))

require 'rubygems'
require 'bundler/setup'

Dir[File.expand_path('../apis/*.rb', __FILE__)].each do |file|
  require file
end

require_relative '../xattack_graph'

require 'rack/test'

def app
  XAttackGraph
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
