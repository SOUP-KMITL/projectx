require_relative 'spec_helper'

describe XAttackGraph do
  describe XAttackGraphAPI::AttackNodes do
    it 'should respond to GET' do
      get '/sessions/1234/nodes'
      expect(last_response).to be_ok
    end
  end
end

