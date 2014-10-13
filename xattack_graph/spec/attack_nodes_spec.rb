require_relative 'spec_helper'

describe XAttackGraph do
  describe XAttackGraphAPI::AttackNodes do
    before(:each) do
      @neo = Neography::Rest.new
    end

    it 'should responds to GET' do
      get '/sessions/1234/nodes'
      expect(last_response).to be_ok
    end

    describe 'SHOW' do
      it 'should gives 404 if not found' do
        get '/sessions/1234/nodes/111'
        expect(last_response.status).to eq(400)
      end
    end
  end
end

