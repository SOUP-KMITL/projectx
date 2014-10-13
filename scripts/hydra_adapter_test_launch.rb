require_relative '../boot'

context = {}
context[:target] = '192.168.56.102'
context[:user_list]  = File.expand_path('../../tmp/user_list.txt', __FILE__)
context[:dictionary] = File.expand_path('../../tmp/dictionary.txt', __FILE__)
context[:tmp]    = File.expand_path('../../tmp', __FILE__)

hydra_adapter    = XAttacker::ThcHydraAdapters::ThcHydraAdapter.new(context: context)
hydra_adapter.run
