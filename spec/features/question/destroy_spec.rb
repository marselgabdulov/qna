require 'rails_helper'

feature 'Author can destroy question', %q{
  In order to get cleaness
  As an authorized user
  I'd like to be able to destroy the question
} do

  given(:author) { create(:user) }
  given(:not_author) { create(:user) }

  before do
    @deleted_question = Question.create(title: 'Some title', body: 'Some body', user_id: author.id)
  end

  scenario 'author tries to destroy the question' do
    sign_in(author)
    visit question_path(@deleted_question)
    click_on 'Delete'

    expect(page).to have_content 'The question was successfully destroyed.'
  end

  scenario 'not an author to tries destroy the question' do
    sign_in(not_author)
    visit question_path(@deleted_question)
    click_on 'Delete'

    expect(page).to have_content 'Only an author can do it.'
  end
end
