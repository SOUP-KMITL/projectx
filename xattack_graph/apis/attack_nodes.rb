require_relative 'helpers/sessions_helper'
require_relative 'helpers/attack_nodes_helper'

module XAttackGraphAPI
  class AttackNodes < Sinatra::Base
    include SessionsHelper
    include AttackNodesHelper

    before do
      @neo = Neography::Rest.new
    end

    get '/sessions/:session_id/nodes' do
      nodes = get_attack_nodes(params[:session_id])
      nodes.map! { |node| node['data'] }
      json nodes
    end

    get '/sessions/:session_id/nodes/:node_addr' do
      node = get_attack_node(params[:session_id], params[:node_addr])
      json node['data']
    end

    post '/sessions/:session_id/nodes' do
      create_attack_node(params[:session_id], params[:properties])
    end

    put '/sessions/:session_id/nodes/:node_addr' do
      update_attack_node(params[:session_id], params[:node_addr], params[:properties])
    end

    delete '/sessions/:session_id/nodes' do
      destroy_all_attack_nodes(params[:session_id])
    end

    delete '/sessions/:session_id/nodes/:node_addr' do
      destroy_attack_node(params[:session_id], params[:node_addr])
    end
  end
end
