require_relative '../spec_helper'

describe AttackGraph::ServiceNode do
  let(:service_node) do
    attack_node = AttackGraph::AttackNode.create(addr: '192.168.99.101')
    # attack_node.services.create
  end

  describe '.all' do
  end

  describe '.find' do
  end

  describe '.where' do
  end

  describe '.clear' do
  end

  describe '#services' do
    it 'returns empty array when has no services' do
      attack_node.save
      expect(attack_node.services).to be_empty
    end
  end

  describe '#save' do
    it 'saves to database backend' do
      before_save_persisted = attack_node.persisted?
      attack_node.save

      expect(before_save_persisted).to be_nil
      expect(attack_node.persisted?).to be_truthy
    end
  end

  describe '#destroy' do
    it 'destroys itself in the database backend'
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

