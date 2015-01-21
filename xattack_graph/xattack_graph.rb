require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/json'
require 'neography'

$:.unshift(File.expand_path('../', __FILE__))
require 'apis/session_nodes'
require 'apis/attack_nodes'
require 'apis/service_nodes'
require 'apis/vuln_nodes'
require 'apis/connections'

class XAttackGraph < Sinatra::Base
  delete '/' do
    neo = Neography::Rest.new
    neo.execute_query('match (n) optional match (n)-[r]->() delete n, r')
    200
  end

  use XAttackGraphAPI::SessionNodes
  use XAttackGraphAPI::AttackNodes
  use XAttackGraphAPI::ServiceNodes
  use XAttackGraphAPI::VulnNodes
  use XAttackGraphAPI::Connections
end
