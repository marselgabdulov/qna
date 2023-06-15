require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:action) { post :create, params: { answer: attributes_for(:answer), question_id: question } }

      it 'saves a new answer in the database' do
        expect { action }.to change(question.answers, :count).by(1)
      end

      it 'saves correct association with the question' do
        action
        expect(assigns(:exposed_answer).question_id).to eq question.id
      end

      it 'redirects to show view' do
        expect(action).to redirect_to assigns(:exposed_answer)
      end
    end

    context 'with invalid attributes' do
      let(:action) { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }

      it 'does not save the answer' do
        expect { action }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        expect(action).to render_template :new
      end
    end
  end
end
