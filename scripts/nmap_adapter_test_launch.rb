require_relative '../boot'

context = {}
context[:target] = '192.168.56.102'
context[:tmp]    = File.expand_path('../../tmp', __FILE__)

nmap_adapter = NmapAdapter.new(context: context)
nmap_adapter.run # this uses NmapAdapter::Strategies::Default
