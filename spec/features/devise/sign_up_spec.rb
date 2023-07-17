require 'rails_helper'

feature 'User can sign up', "
  In order to be able to authenticate
  As an unauthenticated user
  I'd like to be able to register
" do
  given(:user) { create(:user) }

  describe 'Unauthenticated user' do
    background { visit new_user_registration_path }

    scenario 'tries to sign up' do
      clear_emails

      fill_in 'Email', with: 'user@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'

      click_button 'Sign up'
      expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'

      open_email('user@test.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end

    scenario 'tries to sign up with blank parameters' do
      click_button 'Sign up'

      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
    end

    scenario 'tries to sign up with with a non-unique email' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password

      click_button 'Sign up'

      expect(page).to have_content 'Email has already been taken'
    end

    scenario 'tries to sign up with a mismatched password and confirmation' do
      fill_in 'Email', with: 'user@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '123456789'

      click_button 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end

  scenario 'Authenticated user tries to sign up' do
    sign_in(user)
    visit new_user_registration_path

    expect(page).to have_content 'You are already signed in.'
  end
end
