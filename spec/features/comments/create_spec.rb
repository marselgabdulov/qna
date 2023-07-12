require 'rails_helper'

feature 'Anthenticated user can create comment to the question', %q{
  In order clarify question
  As an authorized user
  I'd like to be able to add comment to the quesiton
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'add comment'
    end

    scenario 'tries to add valid comment' do
      fill_in 'Your Comment', with: 'My Comment'
      click_on 'Add Comment'

      expect(page).to have_content 'My Comment'
    end

    scenario 'tries to add invalid comment' do
      click_on 'Add Comment'

      within '.comments' do
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'multiple sessions' do
    scenario 'comment appears on another user page', js: true do
      Capybara.using_session('authenticated user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('unauthenticated user') do
        visit question_path(question)
      end

      Capybara.using_session('authenticated user') do
        click_on 'add comment'
        fill_in 'Your Comment', with: 'text text text'

        click_on 'Add Comment'

        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('unauthenticated user') do
        expect(page).to have_content 'text text text'
      end
    end
  end

  scenario 'Unauthenticated user tries to add comment' do
    visit question_path(question)

    expect(page).to_not have_link 'add comment'
  end
end
