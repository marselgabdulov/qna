require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create :question }
  before { sign_in(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:action) { post :create, params: { answer: attributes_for(:answer), question_id: question } }

      it 'saves a new answer in the database' do
        expect { action }.to change(question.answers, :count).by(1)
      end

      it 'saves correct association with the question' do
        action
        expect(assigns(:answer).question_id).to eq question.id
      end

      it 'redirects to show view' do
        expect(action).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      let(:action) { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }

      it 'does not save the answer' do
        expect { action }.to_not change(Answer, :count)
      end

      it 're-renders question#show view' do
        expect(action).to redirect_to assigns(:question)
      end
    end
  end
end
