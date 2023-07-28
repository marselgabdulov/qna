shared_examples_for 'voted' do
  let(:votable) { create(described_class.controller_name.singularize.to_sym, user: another_user) }

  describe 'POST #vote_up' do
    let(:request_data) { post :vote_up, params: { id: votable }, format: :json }

    context 'authenticated user' do
      context 'not author of the votable' do
        before { login(user) }

        it 'creates vote up' do
          expect { request_data }.to change(votable.votes, :count).by(1)
        end

        it 'renders json response with votable id and raiting' do
          expected = { id: votable.id, raiting: votable.raiting + 1 }.to_json

          request_data
          expect(response.body).to eq expected
        end
      end

      context 'author of the votable' do
        before { login(another_user) }

        it 'does not create vote up' do
          expect { request_data }.to_not change(votable.votes, :count)
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not create vote up' do
        expect { request_data }.to_not change(votable.votes, :count)
      end
    end
  end

  describe 'POST #vote_down' do
    let(:request_data) { post :vote_down, params: { id: votable }, format: :json }
    context 'authenticated user' do
      context 'not author of the votable' do
        before { login(user) }

        it 'creates vote down' do
          expect { request_data }.to change(votable.votes, :count).by(1)
        end

        it 'renders json response with votable id and raiting' do
          expected = { id: votable.id, raiting: votable.raiting - 1 }.to_json

          request_data
          expect(response.body).to eq expected
        end
      end

      context 'author of the votable' do
        before { login(another_user) }

        it 'does not create vote down' do
          expect { request_data }.to_not change(votable.votes, :count)
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not create vote down' do
        expect { request_data }.to_not change(votable.votes, :count)
      end
    end
  end

  describe 'POST #revote' do
    let!(:vote) { create(:vote, user: user, value: 1, votable: votable) }
    let(:request_data) { post :revote, params: { id: votable }, format: :json }

    context 'authenticated user' do
      context 'not author of the votable' do
        before { login(user) }

        it 'removes past vote' do
          expect { request_data }.to change(votable.votes, :count).by(-1)
        end

        it 'renders json response with votable id and raiting' do
          request_data

          expected = { id: votable.id, raiting: votable.raiting }.to_json

          expect(response.body).to eq expected
        end
      end

      context 'author of the question' do
        before { login(another_user) }

        it 'dose not remove past vote' do
          expect { request_data }.to_not change(votable.votes, :count)
        end
      end
    end

    context 'unauthenticated user' do
      it 'dose not remove past vote' do
        expect { request_data }.to_not change(votable.votes, :count)
      end
    end
  end
end
