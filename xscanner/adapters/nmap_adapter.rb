Dir[File.expand_path('../nmap_adapters/strategies/*.rb', __FILE__)].
  each do |file|
  require file
end

class NmapAdapter < AbstractAdapter
  attr_accessor :context

  def initialize(options = {})
    self.context = options[:context]
  end

  def run(strategy = NmapAdapters::Strategies::Default)
    strategy.run(context)
  end
end
