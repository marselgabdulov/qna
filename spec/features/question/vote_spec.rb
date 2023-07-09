require 'rails_helper'

feature 'Authenticated user can vote for the question', %q(
  In order to highlight the question
  As an authenticated user
  I'd like to be able to vote
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_question) { create(:question) }

  describe 'authenticated user' do
    background do
      sign_in(user)
    end

    context 'as an author of the question' do
      background do
        visit question_path(question)
      end

      scenario 'can not vote for his question' do
        expect(page).to_not have_link 'Vote Up'
        expect(page).to_not have_link 'Vote Down'
      end
    end

    context 'as not an author of the question' do
      background do
        visit question_path(another_question)
      end

      scenario 'votes up for the question' do
        click_on 'Vote Up'

        expect(page).to have_content('1')
        expect(page).to_not have_link('Vote Up')
      end

      scenario 'votes down for the question' do
        click_on 'Vote Down'

        expect(page).to have_content('-1')
        expect(page).to_not have_link('Vote Down')
      end

      scenario 're-vote for the question', js: true do
        expect(page).to_not have_link 'Revote'
        click_on 'Vote Up'
        click_on 'Revote'

        expect(page).to have_link 'Vote Up'
        expect(page).to have_link 'Vote Down'
        expect(page).to_not have_link 'Revote'
      end
    end
  end

  scenario 'unauthenticated user can not vote for the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Vote Up'
    expect(page).to_not have_link 'Vote Down'
  end
end
