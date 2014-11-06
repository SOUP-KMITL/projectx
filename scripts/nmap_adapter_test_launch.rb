require_relative '../boot'

context = {}
context[:target] = ARGV[0]
context[:tmp]    = File.expand_path('../../tmp', __FILE__)

p context

nmap_adapter = NmapAdapter.new(context: context)
nmap_adapter.run # this uses NmapAdapter::Strategies::Default
