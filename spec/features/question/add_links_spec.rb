require 'rails_helper'

feature 'User can add links to the question', %q{
  In order to provide additional info to my question
  As a question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/marselgabdulov/6e53bf179913111403653467a6308f8a' }

  describe 'User adds link' do
    background do
      sign_in(user)
      visit new_question_path
      click_on 'add link'
      fill_in 'Title', with: 'Question Title'
      fill_in 'Body', with: 'Question Body'
      fill_in 'Link Name', with: 'My Gist'
    end

    scenario 'with valid url', js: true do
      fill_in 'Link Url', with: gist_url
      click_on 'Save'

      expect(page).to have_link('My Gist', href: gist_url)
    end

    scenario 'with invalid url', js: true do
      fill_in 'Link Url', with: 'invalid'
      click_on 'Save'

      expect(page).to have_content('Links url is not a valid URL')
    end
  end
end
