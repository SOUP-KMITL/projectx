require_relative 'helpers/service_nodes_helper'
require_relative 'helpers/vuln_nodes_helper'

module XAttackGraphAPI
  class VulnNodes < Sinatra::Base
    include ServiceNodesHelper
    include VulnNodesHelper

    before do
      @neo = Neography::Rest.new
    end

    get '/sessions/:session_id/nodes/:node_addr/services/:service_port_id/vulns' do
      vulns = get_vuln_nodes(params[:session_id],
                             params[:node_addr],
                             params[:service_port_id]).map do |vuln|
                               vuln['data']
                             end

      json vulns
    end

    post '/sessions/:session_id/nodes/:node_addr/services/:service_port_id/vulns' do
      vuln_node = create_vuln_node(params[:session_id],
                                   params[:node_addr],
                                   params[:service_port_id],
                                   params[:properties])
      reloaded_properties       = @neo.get_node_properties(vuln_node)
      reloaded_properties[:id]  = vuln_node['self'].match(/data\/node\/(\d+)\Z/).captures.first

      json reloaded_properties
    end

    get '/sessions/:session_id/nodes/:node_addr/services/:service_port_id/vulns/:vuln_id' do
      vuln = get_vuln_node(params[:session_id],
                           params[:node_addr],
                           params[:service_port_id],
                           params[:vuln_id])

      json vuln['data']
    end

    put '/sessions/:session_id/nodes/:node_addr/services/:service_port_id/vulns/:vuln_id' do
      # TODO:
    end

    delete '/sessions/:session_id/nodes/:node_addr/services/:service_port_id/vulns/:vuln_id' do
      # TODO:
    end
  end
end

