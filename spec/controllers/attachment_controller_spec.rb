require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question){ create(:question, :with_file, user: user) }
  before { sign_in(user) }

  describe 'DELETE #purge' do
    it 'deletes attachment file' do
      expect do
        delete :purge, params: { id: question.files.last.id }, format: :js
        question.reload
      end.to change(question.files, :count).by(-1)
    end
  end
end
