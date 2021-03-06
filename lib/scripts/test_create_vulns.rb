require_relative '../xlib'

attack_node  = AttackGraph::AttackNode.create(addr: '192.168.99.101')
service_node = attack_node.services.create service_name: 'ssh',
                                           port_id: 22
puts service_node.class
puts service_node.base_collection_path
puts service_node.base_singular_path

vuln_node    = service_node.vulnerabilities.create name: 'weak_password',
                                                   detail: 'ahhh weak password'
puts vuln_node.class
puts vuln_node.base_collection_path
puts vuln_node.base_singular_path
