require 'rails_helper'

feature 'Author can destroy answer', %q{
  In order to get cleaness
  As an authorized user
  I'd like to be able to destroy the answer
} do

  given(:author) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create(:question) }

  before do
    @deleted_answer = Answer.create(body: 'Some body', user_id: author.id, question_id: question.id)
  end

  scenario 'author tries to destroy the answer' do
    sign_in(author)
    visit question_path(question)
    click_on 'Delete Answer'

    expect(page).to have_content 'The answer was successfully destroyed.'
  end

  scenario 'not an author to tries destroy the answer' do
    sign_in(not_author)
    visit question_path(question)

    expect(page).to_not have_content 'Delete Answer'
  end
end
