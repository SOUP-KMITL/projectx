require_relative '../spec_helper'

describe AttackGraph::ServiceNode do
  let(:session_id) do
    AttackGraph.create_session[:id]
  end

  let(:attack_node) do
    AttackGraph.with_session(session_id) do
      AttackGraph::AttackNode.create(addr: '192.168.99.101')
    end
  end

  let(:service_node) do
    AttackGraph.with_session(session_id) do
      attack_node.services.create(service_name: 'ssh', port_id: 22)
    end
  end

  let(:service_nodes) do
    AttackGraph.with_session(session_id) do
      attack_node.services.create(service_name: 'ssh', port_id: 22)
      attack_node.services.create(service_name: 'ftp', port_id: 21)
      attack_node.services.create(service_name: 'http', port_id: 80)
      attack_node.services.create(service_name: 'https', port_id: 443)
      attack_node.services.create(service_name: 'smtp', port_id: 465)
      attack_node.services
    end
  end

  describe '#vulnerabilities' do
    it 'returns empty array when has no vulnerabilities' do
      AttackGraph.with_session(session_id) do
        expect(service_node.vulnerabilities).to be_empty
      end
    end
  end

  describe '#has_service?' do
    it 'returns the service if has that service' do
      AttackGraph.with_session(session_id) do
        service_nodes
        expect(attack_node.has_service?(:ssh)).to be_truthy
      end
    end

    it 'returns nil if doesn\'t has that service' do
      AttackGraph.with_session(session_id) do
        service_nodes
        expect(attack_node.has_service?(:mysql)).to be_falsy
      end
    end
  end

  describe '#empty?' do
    it 'returns true if has no services' do
      AttackGraph.with_session(session_id) do
        expect(attack_node.services.empty?).to be_truthy
      end
    end

    it 'returns false if has services' do
      AttackGraph.with_session(session_id) do
        service_nodes

        expect(attack_node.services.empty?).to be_falsy
      end
    end
  end

  describe '#count' do
    it 'returns correct number of services' do
      AttackGraph.with_session(session_id) do
        service_nodes

        expect(attack_node.services.count).to eq(5)
      end
    end
  end

  describe '.clear' do
    it 'clears out all the services of that node'
  end

  describe '#each' do
    it 'yields the correct services' do
      AttackGraph.with_session(session_id) do
        services = []
        service_nodes.each do |service_node|
          services << service_node.service_name
        end

        expect(services).to include('ssh')
        expect(services).to include('ftp')
        expect(services).to include('http')
        expect(services).to include('https')
        expect(services).to include('smtp')
        expect(services).to_not include('ftps')
      end
    end
  end

  describe '#find' do
    it 'finds the correct service in the database backend' do
      AttackGraph.with_session(session_id) do
        service_nodes
        sn  = attack_node.services.find(22)
        sn2 = attack_node.services.find(80)

        expect(sn.service_name).to eq('ssh')
        expect(sn2.service_name).to eq('http')
      end
    end
  end

  describe '#reload' do
    it 'caches the services in the first load'
    it 'reload the services'
  end

  describe '#save' do
    it 'saves to database backend' do
      AttackGraph.with_session(session_id) do
        service_node.service_name = 'ftp'
        service_node.save
        service_node2 = attack_node.services.find(22)

        expect(service_node2.service_name).to eq('ftp')
        expect(attack_node.services.count).to eq(1)
      end
    end
  end

  describe '#where' do
    it 'finds the correct services in the database backend'
  end
end
