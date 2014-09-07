require_relative '../boot'
require 'sinatra'

set :tmp do
  File.expand_path('../../tmp', __FILE__)
end

post '/sessions' do
  context = {}
  context[:target] = params[:target]
  context[:tmp]    = settings.tmp
  nmap_adapter     = NmapAdapter.new(context: context)
  nmap_adapter.run
end
