require 'active_support/ordered_options'

module XM
  class CommandBuilder < BasicObject
    def initialize(xmodule_name)
      @xmodule_name = xmodule_name
    end

    def method_missing(m, *args, &block)
      strategy_name = m.to_s
      command = Command.new(xmodule: @xmodule_name,
                            strategy: strategy_name)
      block.call(command.config)
      command
    end
  end

  class Command
    attr_accessor :xmodule, :strategy, :config

    def initialize(options={})
      @xmodule  = options[:xmodule]
      @strategy = options[:strategy] || 'default'
      @config   = Config.new
    end

    def compiled_config
      config.compiled
    end

    def start(*target_strings)
      target_strings = "'#{target_strings.join(', ')}'"
      command        = "#{@xmodule} start #{@strategy}"
      config.compiled.each do |config_key, config_value|
        command << " --#{config_key} #{config_value}"
      end
      command << " #{target_strings}"
      puts "starting: #{command}"
      # TODO: do something
      puts "ended"
    end

    def start_parallel(*target_strings)
    end
  end

  class Config < ActiveSupport::OrderedOptions
    def method_missing(name, *args, &block)
      if block_given?
        subconfig  = self.class.new(true)
        block.call(subconfig)
        self[name] = subconfig
      else
        super
      end
    end

    def compiled
      compile_config(self)
    end

    def compile_config(config, parent=nil)
      compiled_hash = {}

      config.each do |k, v|
        k = "#{parent}-#{k}" unless parent.nil?

        if v.is_a?(Config)
          compiled_hash.merge!(compile_config(v, k))
        else
          compiled_hash[k] = v
        end
      end

      compiled_hash
    end
  end
end
