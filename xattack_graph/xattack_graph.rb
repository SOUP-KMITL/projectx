require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/json'
require 'neography'

$:.unshift(File.expand_path('../', __FILE__))
require 'apis/sessions'
require 'apis/attack_nodes'
require 'apis/service_nodes'
require 'apis/vuln_nodes'

class XAttackGraph < Sinatra::Base
  use XAttackGraphAPI::Sessions
  use XAttackGraphAPI::AttackNodes
  use XAttackGraphAPI::ServiceNodes
  use XAttackGraphAPI::VulnNodes
end
