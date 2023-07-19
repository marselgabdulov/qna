require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'returns success status' do
      expect(response).to have_http_status(:success)
    end

    it 'renders index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    before { get :show, params: { id: question } }

    it 'returns success status' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show template' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before do
      login(user)
      get :new
    end

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new reward for @question' do
      expect(assigns(:question).reward).to be_a_new(Reward)
    end

    it 'assigns a new votes for @question' do
      expect(assigns(:question).votes.first).to be_a_new(Vote)
    end

    it 'returns success status' do
      expect(response).to have_http_status(:success)
    end

    it 'renders new template' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question, user: user) }
    let(:valid_data_request) { post :create, params: { question: attributes_for(:question) } }

    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect { valid_data_request }.to change(Question, :count).by(1)
        end

        it 'returns found status' do
          valid_data_request
          expect(response).to have_http_status(:found)
        end

        it 'user is author of the question' do
          valid_data_request
          expect(user).to be_author_of(assigns(:question))
        end

        it 'redirects to show view' do
          valid_data_request
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        let(:invalid_data_request) { post :create, params: { question: attributes_for(:question, :invalid) } }

        it 'does not save the question' do
          expect { invalid_data_request }.to_not change(Question, :count)
        end

        it 'returns success status' do
          invalid_data_request
          expect(response).to have_http_status(:success)
        end

        it 're-renders new template' do
          invalid_data_request
          expect(response).to render_template :new
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not saves question in the database' do
        expect { valid_data_request }.to_not change(Question, :count)
      end

      it 'redirects to sign in view' do
        valid_data_request
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    let(:question) { create(:question, user: user) }
    let(:valid_data_request) do
      patch :update, params: { id: question,
                               question: { title: 'NewTitle', body: 'NewBody' } }, format: :js
    end

    context 'authenticated user' do
      context 'author of the question' do
        before { login(user) }

        context 'with valid attributes' do
          before { valid_data_request }

          it 'changes question attributes' do
            expect(question.reload.title).to eq 'NewTitle'
            expect(question.reload.body).to eq 'NewBody'
          end

          it 'returns success status' do
            expect(response).to have_http_status(:success)
          end

          it 'renders update template' do
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          let(:invalid_data_request) do
            patch :update, params: { id: question,
                                     question: attributes_for(:question, :invalid) }, format: :js
          end

          it 'returns success status' do
            invalid_data_request
            expect(response).to have_http_status(:success)
          end

          it 'does not change question attributes' do
            expect { invalid_data_request }.to_not change(question, :title)
          end

          it 'renders update template' do
            invalid_data_request
            expect(response).to render_template :update
          end
        end
      end

      context 'not author of the question' do
        before { login(another_user) }

        it 'does not change question attributes' do
          expect { valid_data_request }.to_not change(question, :title)
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not change question attributes' do
        expect { valid_data_request }.to_not change(question, :title)
      end

      it 'returns unauthorized status' do
        valid_data_request
        expect(response).to have_http_status(:unauthorized) # 401
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:another_question) { create(:question) }
    let!(:question) { create(:question, user: user) }
    let(:data_request) { delete :destroy, params: { id: question } }

    context 'authenticated user' do
      context 'author of the question' do
        before { login(user) }

        it 'deletes question from the database' do
          expect { data_request }.to change(Question, :count).by(-1)
        end

        it 'returns found status' do
          data_request
          expect(response).to have_http_status(:found)
        end

        it 'redirects to index view' do
          data_request
          expect(response).to redirect_to questions_path
        end
      end

      context 'not author of the question' do
        before { login(another_user) }

        it 'does not delete quesiton from the database' do
          expect { data_request }.not_to change(Question, :count)
        end

        it 'returns found status' do
          data_request
          expect(response).to have_http_status(:found)
        end

        it 'redirects to root path' do
          data_request
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not delete quesiton from the database' do
        expect { data_request }.not_to change(Question, :count)
      end

      it 'returns 302 status' do
        data_request
        expect(response).to have_http_status(:found)
      end

      it 'redirects to sign in view' do
        data_request
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
