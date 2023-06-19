require 'rails_helper'

feature 'Authorized user can create answer', %q{
  In order to get answer to a community
  As an authorized user
  I'd like to be able to answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authorized user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question' do
      fill_in 'Your answer', with: 'My Answer'
      click_on 'Answer'

      expect(current_path).to eq(question_path(question))
      expect(page).to have_content('Your answer successfully created.')
      within('.answers') do
        expect(page).to have_content('My Answer')
      end
    end

    scenario 'answers the question with errors' do
      click_on 'Answer'

      expect(page).to have_content("Body can't be blank")
    end
  end

  scenario 'Unauthorized user tries to answer the question' do
    visit question_path(question)
    fill_in 'answer[body]', with: 'My Answer'
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
