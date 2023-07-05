require 'rails_helper'

feature "Author of the question can manipulate with question's links", %q{
  In order to provide additional info to my question
  As a question's author
  I'd like to be able to add/delete links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:question_with_link) { create(:question, :with_link, user: user,) }
  given(:gist_url) { 'https://gist.github.com/marselgabdulov/6e53bf179913111403653467a6308f8a' }

  describe 'Author adds link when create question' do
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

      expect(page).to have_content('gistfile1.txt hosted with ❤ by GitHub')
    end

    scenario 'with invalid url', js: true do
      fill_in 'Link Url', with: 'invalid'
      click_on 'Save'

      expect(page).to have_content('Links url is not a valid URL')
    end
  end

  scenario 'Author adds new link when edit existing question', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Edit Question'

    within first('#edit-question-links') do
      click_on 'add link'
      fill_in 'Link Name', with: 'Google'
      fill_in 'Link Url', with: 'https://google.com'
    end

    click_on 'Save'

    expect(page).to have_link('Google', href: 'https://google.com')
  end

  scenario 'Author deletes the link when edit existing question', js: true do
    sign_in(user)
    visit question_path(question_with_link)
    click_on 'Edit Question'

    within first('#edit-question-links') do
      click_on 'remove link'
    end

    click_on 'Save'

    expect(page).to_not have_link('Google', href: 'https://google.com')
  end
end
