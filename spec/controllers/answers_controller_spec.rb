require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create :question }
  before { sign_in(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question) }

    it 'destroyes the answer' do
      expect do
        delete :destroy, params: { id: answer }, format: :js
      end.to change(question.answers, :count).by(-1)
    end
  end

  describe 'POST #mark_as_best' do
    let!(:answer) { create(:answer, question: question) }

    it 'marks answer as the best' do
      expect do
        post :mark_as_best, params: { id: answer }, format: :js
        answer.reload
      end.to change(answer, :best).to(true)
    end
  end

  describe 'POST #vote_up' do
    let(:answer) { create(:answer, user: another_user) }

    context 'authenticated user' do
      context 'not author of the answer' do
        before { login(user) }

        it 'create vote up' do
          expect {
            post :vote_up, params: { id: answer }, format: :json
          }.to change(Vote, :count).by(1)
        end

        it 'renders json with answer id and rating' do
          rendered_body = { id: answer.id, rating: answer.rating + 1 }.to_json

          post :vote_up, params: { id: answer }, format: :json
          expect(response.body).to eq rendered_body
        end
      end

      context 'author fo the answer' do
        before { login(another_user) }

        it 'does not create vote up' do
          expect {
            post :vote_up, params: { id: answer }, format: :json
          }.to_not change(Vote, :count)
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not create vote up' do
        sign_out(user)
        expect {
          post :vote_up, params: { id: answer }, format: :json
        }.to_not change(Vote, :count)
      end
    end
  end

  describe 'POST #vote_down' do
    let(:answer) { create(:answer, user: another_user) }

    context 'authenticated user' do
      context 'not author of the answer' do
        before { login(user) }

        it 'create vote down' do
          expect {
            post :vote_down, params: { id: answer }, format: :json
          }.to change(Vote, :count).by(1)
        end

        it 'renders json with answer id and rating' do
          rendered_body = { id: answer.id, rating: answer.rating - 1 }.to_json

          post :vote_down, params: { id: answer }, format: :json
          expect(response.body).to eq rendered_body
        end
      end

      context 'author of the answer' do
        before { login(another_user) }

        it 'does not create vote down' do
          expect {
            post :vote_down, params: { id: answer }, format: :json
          }.to_not change(Vote, :count)
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not create vote down' do
        sign_out(user)
        expect {
          post :vote_down, params: { id: answer }, format: :json
        }.to_not change(Vote, :count)
      end
    end
  end

  describe 'POST #revote' do
    let(:answer) { create(:answer) }
    let!(:vote) { create(:vote, user: user, value: 1, votable: answer) }

    context 'authenticated user' do
      context 'not author of the answer' do
        before { login(user) }

        it 're-vote votes' do
          expect {
            post :revote, params: { id: answer }, format: :json
          }.to change(Vote, :count).by(-1)
        end

        it 'renders json with answer id and rating' do
          post :revote, params: { id: answer }, format: :json
          rendered_body = { id: answer.id, rating: answer.rating }.to_json
          expect(response.body).to eq rendered_body
        end
      end

      context 'author of the answer' do
        before { login(another_user) }

        it 'dose not make re-vote' do
          expect {
            post :revote, params: { id: answer }, format: :json
          }.to_not change(Vote, :count)
        end
      end
    end

    context 'unauthenticated user' do
      it 'dose not make re-vote' do
        sign_out(user)
        expect {
          post :revote, params: { id: answer }, format: :json
        }.to_not change(Vote, :count)
      end
    end
  end
end
