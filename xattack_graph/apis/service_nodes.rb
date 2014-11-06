require_relative 'helpers/attack_nodes_helper'
require_relative 'helpers/service_nodes_helper'

module XAttackGraphAPI
  class ServiceNodes < Sinatra::Base
    include AttackNodesHelper
    include ServiceNodesHelper

    before do
      @neo = Neography::Rest.new
    end

    get '/sessions/:session_id/nodes/:node_addr/services' do
      services = get_service_nodes(params[:session_id], params[:node_addr]).map do |service|
        service['data']
      end

      json services
    end

    get '/sessions/:session_id/nodes/:node_addr/services/:service_port_id' do
      service = get_service_node(params[:session_id], params[:node_addr], params[:service_port_id])

      json service['data']
    end

    post '/sessions/:session_id/nodes/:node_addr/services' do
      service_node = create_service_node(params[:session_id],
                                         params[:node_addr],
                                         params[:properties])
      json service_node['data']
    end

    put '/sessions/:session_id/nodes/:node_addr/services/:service_port_id' do
      service_node = update_service_node(params[:session_id],
                                         params[:node_addr],
                                         params[:service_port_id],
                                         params[:properties])
      json service_node['data']
    end

    # DESTROY
    delete '/sessions/:session_id/nodes/:node_addr/services/:service_port_id' do
    end
  end
end
