require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    let(:service) { double('SearchService') }

    before do
      allow(SearchService).to receive(:new).and_return(service)
      allow(service).to receive_message_chain(:call, :paginate)
      get :index, params: { resource: 'All', query: '' }
    end

    it 'returns success status' do
      expect(response).to have_http_status(:success)
    end

    it 'renders index template' do
      expect(response).to render_template :index
    end
  end
end
