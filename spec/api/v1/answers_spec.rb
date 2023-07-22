require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:another_user) { create(:user) }
  let(:another_access_token) { create(:access_token, resource_owner_id: another_user.id) }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer) { answers.first }
      let(:answer_json) { json['answers'].first }
      let!(:answers) { create_list(:answer, 2, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Status Successful'

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'contains user object' do
        expect(answer_json['user']['id']).to eq answer.user.id
      end

      it 'contains short body' do
        expect(answer_json['short_body']).to eq answer.body.truncate(20)
      end

      it 'returns all public fields' do
        %w[id user_id body best rating created_at updated_at].each do |attr|
          expect(answer_json[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_json['user']['id']).to eq answer.user.id
      end
    end
  end

end
