require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    let(:comments) { question.comments }
    let(:valid_data_request) do
      post :create, params: { question_id: question,
                              comment: attributes_for(:comment) }, format: :js
    end

    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new comment in the database' do
          expect { valid_data_request }.to change(comments, :count).by(1)
        end

        it 'returns success status' do
          valid_data_request
          expect(response).to have_http_status(:success)
        end

        it 'user is author of the comment' do
          valid_data_request
          expect(user).to be_author_of(assigns(:comment))
        end

        it 'renders create template' do
          valid_data_request
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        let(:invalid_data_request) do
          post :create, params: { question_id: question,
                                  comment: attributes_for(:comment, :invalid) }, format: :js
        end

        it 'does not save comment in the database' do
          expect { invalid_data_request }.to_not change(comments, :count)
        end

        it 'returns success status' do
          invalid_data_request
          expect(response).to have_http_status(:success)
        end

        it 'renders create template' do
          invalid_data_request
          expect(response).to render_template :create
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not save comment in the database' do
        expect { valid_data_request }.to_not change(comments, :count)
      end

      it 'returns unauthorized status' do
        valid_data_request
        expect(response).to have_http_status(:unauthorized) # 401
      end
    end
  end
end
