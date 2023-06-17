require 'rails_helper'

feature 'User can sign out', %q{
  In order to close session
  As an authorized user
  I'd like to be able to sign out
} do
  given(:user) { create(:user) }

  scenario 'Registered user tries to sign out' do
    sign_in(user)
    visit questions_path
    click_on 'Log Out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
