require_relative '../boot'
require 'sinatra'

set :tmp do
  File.expand_path('../../tmp', __FILE__)
end

post '/sessions' do
  targets = params[:targets]
  
  context = {}
  context[:tmp]    = settings.tmp

  targets.each do |target|
    context[:target] = target

    nmap_adapter     = NmapAdapter.new(context: context)
    nmap_adapter.run
  end
end
