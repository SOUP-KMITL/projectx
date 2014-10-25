require_relative '../spec_helper'

describe AttackGraph::AttackNode do
  let(:session_id) do
    AttackGraph.create_session[:id]
  end

  let(:attack_node) do
    AttackGraph::AttackNode.new(addr: '192.168.99.101')
  end

  let(:attack_nodes) do
    AttackGraph.with_session(session_id) do
      (101..110).to_a.map do |i|
        AttackGraph::AttackNode.create(addr: "192.168.99.#{i}")
      end
    end
  end

  describe '.all' do
    it 'returns all of attack nodes in the database backend' do
      before_count = AttackGraph::AttackNode.all.count
      attack_nodes

      expect(before_count).to eq(0)
      expect(AttackGraph::AttackNode.all.count).to eq(10)
      expect(AttackGraph::AttackNode.all[1].addr).to eq('192.168.99.102')
    end
  end

  describe '.count' do
    it 'returns the correct number of attack nodes' do
      attack_nodes
      AttackGraph.with_session(session_id) do
        before_count = AttackGraph::AttackNode.count
        attack_nodes[3].destroy
        attack_nodes[4].destroy
        attack_nodes[5].destroy

        expect(before_count).to eq(10)
        expect(AttackGraph::AttackNode.count).to eq(7)
      end
    end
  end

  describe '.find' do
    it 'finds the right attack node' do
      attack_nodes
      found = AttackGraph::AttackNode.find('192.168.99.106')

      expect(found.addr).to eq('192.168.99.106')
    end

    it 'returns nil when it does not found any attack node' do
      attack_nodes
      found = AttackGraph::AttackNode.find('192.168.99.120')

      expect(found).to be_nil
    end
  end

  describe '.where' do
    it 'returns the correct attack nodes'
  end

  describe '.clear' do
    it 'clears all attack nodes' do
      attack_nodes
      AttackGraph.with_session(session_id) do
        before_count = AttackGraph::AttackNode.count
        AttackGraph::AttackNode.clear

        expect(before_count).to eq(10)
        expect(AttackGraph::AttackNode.count).to eq(0)
      end
    end
  end

  describe '#services' do
    it 'returns empty array when has no services' do
      AttackGraph.with_session(session_id) do
        attack_node.save
        expect(attack_node.services).to be_empty
      end
    end

    it 'returns service array when has services'
  end

  describe '#save' do
    it 'saves to database backend' do
      before_save_persisted = attack_node.persisted?
      AttackGraph.with_session(session_id) do
        attack_node.save

        expect(before_save_persisted).to be_nil
        expect(attack_node.persisted?).to be_truthy
      end
    end
  end

  describe '#destroy' do
    it 'destroys itself in the database backend' do
      AttackGraph.with_session(session_id) do
        attack_node.save
        before_delete_persisted = attack_node.persisted?
        attack_node.destroy

        expect(before_delete_persisted).to be_truthy
        expect(attack_node.persisted?).to be_falsy
      end
    end
  end

  describe '#persisted?' do
    it 'returns nil when not persisted' do
      expect(attack_node.persisted?).to be_nil
    end
  end

  describe '#addr' do
    it 'returns correct address' do
      expect(attack_node.addr).to eq('192.168.99.101')
    end
  end
end
