# Simple script that bootup all the objects into the object space
$:.unshift(File.expand_path('../', __FILE__))
# XAttackGraph
require 'lib/attack_graph/node'
Dir[File.expand_path('../lib/attack_graph/*.rb', __FILE__)].each do |file|
  require file
end

# XScanner
Dir[File.expand_path('../xscanner/*.rb', __FILE__)].each { |file| require file }
require 'xscanner/adapters/abstract_adapter'
Dir[File.expand_path('../xscanner/adapters/*.rb', __FILE__)].each do |file|
  require file
end

# XAttacker
Dir[File.expand_path('../xattacker/*.rb', __FILE__)].each { |file| require file }
require 'xattacker/adapters/abstract_adapter'
Dir[File.expand_path('../xattacker/adapters/*.rb', __FILE__)].each do |file|
  require file
end
Dir[File.expand_path('../xattacker/adapters/*/*.rb', __FILE__)].each do |file|
  require file
end
