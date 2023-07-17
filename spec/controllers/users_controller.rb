require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:session) { { oauth: { 'provider' => 'facebook', 'uid' => '123456' } } }

  describe '#noemail_signup' do
    context 'without oauth params' do
      it 'redirect to root path' do
        post :noemail_signup
        expect(response).to redirect_to root_path
      end
    end

    context 'with oauth params' do
      context 'with wrong email' do
        it 'render error when wrong format' do
          post :noemail_signup, params: { user: { email: 'wrong_email' } }, session: session
          expect(response).to render_template :noemail_signup
        end

        it 'render error when blank email' do
          post :noemail_signup, params: { user: { email: '' } }, session: session
          expect(response).to render_template :noemail_signup
        end
      end

      context 'with an existing email' do
        let!(:user) { create(:user, email: 'my@email.com') }

        it 'render error' do
          post :noemail_signup, params: { user: { email: 'my@email.com' } }, session: session
          expect(response).to render_template :noemail_signup
        end
      end

      context 'with correct email' do
        it 'create authorization' do
          expect do
            post :noemail_signup, params: { user: { email: 'my@email.com' } }, session: session
          end.to change(Authorization, :count).by(1)
        end

        it 'redirect to root path' do
          post :noemail_signup, params: { user: { email: 'my@email.com' } }, session: session
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
