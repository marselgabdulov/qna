require 'rails_helper'

feature 'User can see question and answers', %q{
  In order to get information from a community
  As an authorized user or a guest user
  I'd like to be able to see the question and it's answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, :with_answer) }

  scenario 'Authorized user can see question and answers' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content('Question Title')
    expect(page).to have_content('Answer Body')
  end

  scenario 'Anuthorized user can see question and answers' do
    visit question_path(question)

    expect(page).to have_content('Question Body')
    expect(page).to have_content('Answer Body')
  end
end
