require 'rails_helper'

feature 'User can add links to the answer', %q{
  In order to provide additional info to my answer
  As a answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/marselgabdulov/6e53bf179913111403653467a6308f8a' }

  scenario 'User adds link when asks the answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your Answer', with: 'Answer Body'
    fill_in 'Link Name', with: 'My Gist'
    fill_in 'Link Url', with: gist_url

    click_on 'Create Answer'

    within '.answers' do
      expect(page).to have_link 'My Gist', href: gist_url
    end
  end

end
