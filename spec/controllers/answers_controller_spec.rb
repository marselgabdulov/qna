require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe 'POST #create' do
    let(:answers) { question.answers }
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:valid_data_request) do
      post :create, params: { question_id: question,
                              answer: attributes_for(:answer) }, format: :js
    end

    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'returns success status' do
          valid_data_request
          expect(response).to have_http_status(:success)
        end

        it 'saves a new answer in the database' do
          expect { valid_data_request }.to change(answers, :count).by(1)
        end

        it 'user is author of the answer' do
          valid_data_request
          expect(user).to be_author_of(assigns(:answer))
        end

        it 'renders create template' do
          valid_data_request
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        let(:invalid_data_request) do
          post :create, params: { question_id: question,
                                  answer: attributes_for(:answer, :invalid) }, format: :js
        end

        it 'returns success status' do
          invalid_data_request
          expect(response).to have_http_status(:success)
        end

        it 'does not save answer in the database' do
          expect { invalid_data_request }.to_not change(answers, :count)
        end

        it 'renders create template' do
          invalid_data_request
          expect(response).to render_template :create
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not save answer in the database' do
        expect { valid_data_request }.to_not change(answers, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:valid_data_request) do
      patch :update, params: { id: answer,
                               answer: { body: 'NewBody' } }, format: :js
    end

    context 'authenticated user' do
      context 'auhtor of the answer' do
        before { login(user) }

        context 'with valid attributes' do
          before { valid_data_request }

          it 'returns success status' do
            expect(response).to have_http_status(:success)
          end

          it 'changes answer attributes' do
            expect(answer.reload.body).to eq 'NewBody'
          end

          it 'renders update template' do
            expect(response).to render_template :update
          end
        end

        context 'with ivalid attributes' do
          let(:invalid_data_request) do
            patch :update, params: { id: answer,
                                     answer: attributes_for(:answer, :invalid) }, format: :js
          end

          it 'does not change answer attributes' do
            expect { invalid_data_request }.to_not change(answer, :body)
          end

          it 'returns success status' do
            invalid_data_request
            expect(response).to have_http_status(:success)
          end

          it 'renders update view template' do
            invalid_data_request
            expect(response).to render_template :update
          end
        end

        context 'not author of the answer' do
          before { login(another_user) }

          it 'does not change answer attributes' do
            expect { valid_data_request }.to_not change(answer, :body)
          end
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not change answer attributes' do
        expect { valid_data_request }.to_not change(answer, :body)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:request_data) { delete :destroy, params: { id: answer }, format: :js }

    context 'authenticated user' do
      context 'author of the answer' do
        before { login(user) }

        it 'returns success status' do
          expect(response).to have_http_status(:success)
        end

        it 'deletes answer from the database' do
          expect { request_data }.to change(Answer, :count).by(-1)
        end

        it 'renders destroy template' do
          request_data
          expect(response).to render_template :destroy
        end
      end

      context 'not author of the answer' do
        before { login(another_user) }

        it 'does not delete answer from the database' do
          expect { request_data }.not_to change(Answer, :count)
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not delete answer from the database' do
        expect { request_data }.not_to change(Answer, :count)
      end
    end
  end

  describe 'POST #mark_as_best' do
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question) }
    let(:request_data) { post :mark_as_best, params: { id: answer }, format: :js }

    context 'authenticated user' do
      context 'author of the question' do
        before do
          login(user)
          request_data
        end

        it 'assigns requested answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it 'returns success status' do
          expect(response).to have_http_status(:success)
        end

        it 'updates best attribute' do
          expect(answer.reload.best).to be true
        end

        it 'renders choose best template' do
          expect(response).to render_template :mark_as_best
        end
      end

      context 'not author of the question' do
        before do
          login(another_user)
          request_data
        end

        it 'does not update best attribute' do
          expect(answer.reload.best).to_not be true
        end
      end
    end

    context 'unauthenticated user' do
      before { request_data }

      it 'does not update best attribute' do
        expect(answer.reload.best).to_not be true
      end
    end
  end
end
