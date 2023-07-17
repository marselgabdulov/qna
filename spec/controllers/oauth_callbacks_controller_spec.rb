require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  %i[github vkontakte].each do |provider|
    describe "Oauth provider #{provider}" do
      let(:oauth_data) { { 'provider' => provider.to_s, 'uid' => '789' } }
      let(:oauth_data_with_email) { { 'provider' => provider.to_s, 'uid' => '789', info: { email: 'my@email.com ' } } }

      it 'finds user from oauth data' do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)

        expect(User).to receive(:find_for_oauth).with(oauth_data)
        get provider
      end

      context 'returned email' do
        before do
          allow(request.env).to receive(:[]).and_call_original
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data_with_email)
        end

        context 'user persisted' do
          let!(:user) { create(:user) }

          before do
            allow(User).to receive(:find_for_oauth).and_return(user)
            get provider
          end

          it 'login user' do
            expect(subject.current_user).to eq user
          end

          it 'redirects to root path' do
            expect(response).to redirect_to root_path
          end
        end

        context 'user not persisted' do
          before do
            allow(User).to receive(:find_for_oauth).and_return(nil)
            get provider
          end

          it 'redirects to root path' do
            expect(response).to redirect_to root_path
          end

          it 'does not login user' do
            expect(subject.current_user).to_not be
          end
        end
      end

      context 'did not return email' do
        before do
          allow(request.env).to receive(:[]).and_call_original
          allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        end

        context 'user persisted' do
          let!(:user) { create(:user) }

          before do
            allow(User).to receive(:find_for_oauth).and_return(user)
            get provider
          end

          it 'login user' do
            expect(subject.current_user).to eq user
          end

          it 'redirects to root path' do
            expect(response).to redirect_to root_path
          end
        end

        context 'user not persisted' do
          before do
            allow(User).to receive(:find_for_oauth).and_return(nil)
            get provider
          end

          it 'render email request page' do
            expect(response).to render_template 'users/noemail_signup'
          end

          it 'does not login user' do
            expect(subject.current_user).to_not be
          end
        end
      end
    end
  end
end
