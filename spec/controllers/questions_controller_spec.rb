require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }


    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for the question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns the new links to @answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question)}, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id:question, question: { title: '1234567890', body: '1234567890' } }, format: :js
        question.reload

        expect(question.title).to eq '1234567890'
        expect(question.body).to eq '1234567890'
      end

      it 'renders update view' do
        patch :update, params: { id:question, question: { title: '1234567890', body: '1234567890' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid)}, format: :js }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq 'Question Title'
        expect(question.body).to eq 'Question Body'
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      login(user)
      @deleted_question = Question.create(title: 'Some title', body: 'Some body', user_id: user.id)
    end

    it 'deletes the question' do
      expect { delete :destroy, params: { id: @deleted_question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: @deleted_question }
      expect(response).to redirect_to questions_path
    end
  end

  describe 'POST #vote_up' do
    let(:question) { create(:question, user: another_user) }

    context 'authenticated user' do
      context 'not author of the quesiton' do
        before { login(user) }

        it 'create vote up' do
          expect {
            post :vote_up, params: { id: question }, format: :json
          }.to change(Vote, :count).by(1)
        end

        it 'renders json with question id and rating' do
          rendered_body = { id: question.id, rating: question.rating + 1 }.to_json

          post :vote_up, params: { id: question }, format: :json
          expect(response.body).to eq rendered_body
        end
      end

      context 'author of the question' do
        before { login(another_user) }

        it 'does not create vote up' do
          expect {
            post :vote_up, params: { id: question }, format: :json
          }.to_not change(Vote, :count)
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not create vote up' do
        expect {
          post :vote_up, params: { id: question }, format: :json
        }.to_not change(Vote, :count)
      end
    end
  end

  describe 'POST #vote_down' do
    let(:question) { create(:question, user: another_user) }

    context 'authenticated user' do
      context 'not author of the question' do
        before { login(user) }

        it 'create voted down' do
          expect {
            post :vote_down, params: { id: question }, format: :json
          }.to change(Vote, :count).by(1)
        end

        it 'renders json with question id and rating' do
          rendered_body = { id: question.id, rating: question.rating - 1 }.to_json

          post :vote_down, params: { id: question }, format: :json
          expect(response.body).to eq rendered_body
        end
      end

      context 'author of the question' do
        before { login(another_user) }

        it 'does not create vote down' do
          expect {
            post :vote_down, params: { id: question }, format: :json
          }.to_not change(Vote, :count)
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not create vote down' do
        expect {
          post :vote_down, params: { id: question }, format: :json
        }.to_not change(Vote, :count)
      end
    end
  end

  describe 'POST #revote' do
    let(:question) { create(:question) }
    let!(:vote) { create(:vote, user: user, value: 1, votable: question) }

    context 'authenticated user' do
      context 'not author of the question' do
        before { login(user) }

        it 're-vote votes' do
          expect {
            post :revote, params: { id: question }, format: :json
          }.to change(Vote, :count).by(-1)
        end

        it 'renders json with question id and rating' do
          post :revote, params: { id: question }, format: :json
          rendered_body = { id: question.id, rating: question.rating }.to_json
          expect(response.body).to eq rendered_body
        end
      end

      context 'author of the question' do
        before { login(another_user) }

        it 'dose not make re-vote' do
          expect {
            post :revote, params: { id: question }, format: :json
          }.to_not change(Vote, :count)
        end
      end
    end

    context 'unauthenticated user' do
      it 'dose not make re-vote' do
        expect {
          post :revote, params: { id: question }, format: :json
        }.to_not change(Vote, :count)
      end
    end
  end
end
