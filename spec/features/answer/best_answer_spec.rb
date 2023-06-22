require 'rails_helper'

feature 'Author of the question can choose best answer', %q{
  In order to community find the best answer
  As an author of the question
  I'd like to be able to choose the best answer
} do

  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:first_answer) { create(:answer, question: question, user: user) }
  given!(:second_answer) { create(:answer, question: question, user: user) }

  describe 'Author' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'tries to mark answer as the best', js: true do
      find_by_id("#{first_answer.id}").click_link('Best Answer')

      expect(page.body).to match /#{first_answer.body}.*#{second_answer.body}/m
    end

    scenario 'tries to mark another answer as the best', js: true do
      find_by_id("#{second_answer.id}").click_link('Best Answer')

      expect(page.body).to match /#{second_answer.body}.*#{first_answer.body}/m
    end
  end

  scenario 'Not an author tries to mark answer as the best' do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_content('Best answer')
  end
end
