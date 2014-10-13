require_relative '../spec_helper'

describe AttackGraph::VulnNode do
  let(:attack_node) do
    AttackGraph::AttackNode.create(addr: '192.168.99.101')
  end

  let(:service_node) do
    attack_node.services.create(service_name: 'http', port_id: 80)
  end

  let(:vuln_node) do
    service_node.vulnerabilities.create(name: 'xss', detail: 'XSS at /pages')
  end

  let(:vuln_nodes) do
    vulns = []
    vulns << service_node.vulnerabilities.create(name: 'xss', detail: 'XSS at /pages')
    vulns << service_node.vulnerabilities.create(name: 'csrf', detail: 'CSRF at /users')
    vulns << service_node.vulnerabilities.create(name: 'lfi', detail: 'LFI at /posts')
    vulns << service_node.vulnerabilities.create(name: 'rfi', detail: 'RFI at /posts')
    vulns
  end

  describe '#id' do
    it 'returns id' do
      expect(vuln_node.id).to_not be_nil
    end
  end

  describe '#empty?' do
    it 'returns true if has no vulnerabilities' do
      expect(service_node.vulnerabilities.empty?).to be_truthy
    end

    it 'returns false if has vulnerabilities' do
      vuln_nodes

      expect(service_node.vulnerabilities.empty?).to be_falsy
    end
  end

  describe '#count' do
    it 'returns correct number of vulnerabilities' do
      vuln_nodes

      expect(service_node.vulnerabilities.count).to eq(4)
    end
  end

  describe '#find' do
    it 'finds the correct service in the database backend' do
      ids = vuln_nodes.map(&:id)
      vn  = service_node.vulnerabilities.find(ids[0])
      vn2 = service_node.vulnerabilities.find(ids[1])
      vn3 = service_node.vulnerabilities.find(ids.last.to_i+1)

      expect(vn.name).to eq('xss')
      expect(vn2.name).to eq('csrf')
      expect(vn3).to be_nil
    end
  end

  describe '#reload' do
    it 'caches the vulnerabilities in the first load'
    it 'reload the vulnerabilities'
  end

  describe '#save' do
    it 'saves to database backend'
  end

  describe '#where' do
    it 'finds the correct vulns in the database backend'
  end
end
