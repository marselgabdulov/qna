require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question){ create(:question, :with_file, user: user) }
  let(:request_data) { delete :destroy, params: { id: question.files.last.id }, format: :js }
  before { sign_in(user) }

  describe 'DELETE #destroy' do
    it 'deletes attachment file' do
      expect do
        request_data
        question.reload
      end.to change(question.files, :count).by(-1)
    end
  end
end
