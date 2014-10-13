# Start Neo4j and XAttackGraph before running the specs

require_relative '../xlib'
require 'neography'

ENV["XAG_SPEC_HOST"] ||= "localhost"
ENV["XAG_SPEC_PORT"] ||= "9292"

neo = Neography::Rest.new

RSpec.configure do |config|
  config.before(:each) do
    neo.execute_query("match (n) optional match (n)-[r]->() delete n, r")
  end
end
