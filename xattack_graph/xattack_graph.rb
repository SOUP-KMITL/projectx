require 'sinatra/base'
require 'sinatra/json'
require 'neography'

require_relative 'apis/attack_nodes'
require_relative 'apis/service_nodes'

class XAttackGraph < Sinatra::Base
  use XAttackGraphAPI::AttackNodes
  use XAttackGraphAPI::ServiceNodes
end
