require 'rails_helper'

feature 'User can sign in', "
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
" do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  describe 'OAuth' do
    background { visit new_user_session_path }

    describe 'github with email' do
      scenario 'new user' do
        mock_auth_hash(:github, 'my@email.com')
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end

      scenario 'user exists' do
        create(:user, email: 'my@email.com')

        mock_auth_hash(:github, 'my@email.com')
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end
    end

    describe 'vkontakte' do
      describe 'without email' do
        background do
          mock_auth_hash(:vkontakte)
          click_on 'Sign in with Vkontakte'
        end

        scenario 'get email' do
          clear_emails

          expect(page).to have_content 'Please enter your email address to complete registration.'
          fill_in 'Email', with: 'my@email.com'
          click_on 'Save'

          expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account. After confirmation, sign in again.'

          open_email('my@email.com')
          current_email.click_link 'Confirm my account'
          expect(page).to have_content 'Your email address has been successfully confirmed.'
        end

        scenario 'user exists' do
          create(:user, email: 'my@email.com')

          fill_in 'Email', with: 'my@email.com'
          click_on 'Save'

          expect(page).to have_content 'Email has already been taken'
        end

        scenario 'email is blank' do
          click_on 'Save'
          expect(page).to have_content "Email can't be blan"
        end

        scenario 'email is invalid' do
          fill_in 'Email', with: '123'

          click_on 'Save'
          expect(page).to have_content 'Email is invalid'
        end
      end
    end
  end
end
