require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }
  let(:subscriptions) { user.subscriptions }

  describe 'POST #create' do
    let(:data_request) do
      post :create, params: { question_id: question }, format: :js
    end

    context 'authenticated user' do
      before { login(user) }

      context 'unsubscribed user' do
        it 'creates subscription' do
          expect { data_request }.to change(subscriptions, :count).by(1)
        end

        it 'returns success status' do
          data_request
          expect(response).to have_http_status(:success)
        end

        it 'renders create template' do
          data_request
          expect(response).to render_template :create
        end
      end

      context 'subscribed user' do
        let!(:subscription) { create(:subscription, user: user, question: question) }

        it 'does not create subscription' do
          expect { data_request }.to_not change(subscriptions, :count)
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not create subscription' do
        expect { data_request }.to_not change(Subscription, :count)
      end

      it 'returns unauthorized status' do
        data_request
        expect(response).to have_http_status(:unauthorized) # 401
      end
    end
  end

end
