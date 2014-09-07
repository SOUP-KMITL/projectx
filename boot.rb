# Simple script that bootup all the objects into the object space
$:.unshift(File.expand_path('../', __FILE__))

Dir[File.expand_path('../xscanner/*.rb', __FILE__)].each { |file| require file }
require 'xscanner/adapters/abstract_adapter'
Dir[File.expand_path('../xscanner/adapters/*.rb', __FILE__)].each do |file|
  require file
end
