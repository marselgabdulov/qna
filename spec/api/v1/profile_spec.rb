require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'CONTENT_TYPE': 'application/json', 'ACCEPT': 'application/json' } }
  let(:method) { :get }
  let(:api_path) {'/api/v1/profiles/me'  }
  it_behaves_like 'API Authorizable'

  describe 'GET /api/v1/profiles/me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get api_path, headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if token is invalid' do
        get api_path, params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:user) { users.first }
      let!(:users) { create_list(:user, 2) }
      let(:user_response) { json['users'].first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Status Successful'

      it 'returns all public fields' do
        %w[id email created_at updated_at admin].each do |attr|
          expect(user_response[attr]).to eq user.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(user_response).to_not have_key(attr)
        end
      end
    end
  end
end
