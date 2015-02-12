lb = '192.168.56.110'
w1 = '192.168.56.107'
w2 = '192.168.56.108'
db = '192.168.56.109'

update_progress(10)

phase :scanning do
  nmap_adapter.simple do
  end.start(lb, w1, w2, db)
end

sleep 320.0
update_progress(40)

phase :after_scanning do
  s_inf.app_db do
  end.start
end

sleep 2.0
update_progress(50)

phase :attacking do
  hydra_adapter.ssh do |config|
    config.user_list  = File.expand_path('../../resources/user_list.txt', __FILE__)
    config.dictionary = File.expand_path('../../resources/dictionary.txt', __FILE__)
    config.output     = File.expand_path("../../resources/hydra_result#{Time.now.to_i}.txt", __FILE__)
  end.start(lb, w1, w2, db)

  hydra_adapter.mysql do |config|
    config.user_list  = File.expand_path('../../resources/user_list.txt', __FILE__)
    config.dictionary = File.expand_path('../../resources/dictionary.txt', __FILE__)
    config.output     = File.expand_path("../../resources/hydra_result#{Time.now.to_i + 1}.txt", __FILE__)
  end.start(db)

  nikto_adapter.simple do
  end.start(w1, w2)

  nikto_adapter.simple do |config|
    config.port = 443
  end.start(lb)
end

sleep 150.0
update_progress(80)

phase :reporting do
  all_in_one.json do
  end.start('all_in_one.json')
end

sleep 2.0
update_progress(100)
