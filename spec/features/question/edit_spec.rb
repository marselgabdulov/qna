require 'rails_helper'

feature 'User can edit his question', %q{
  In order to get answer from a community
  As an authorized user
  I'd like to be able to edit my question
} do

  given(:author) { create :user }
  given(:not_an_author) { create :user }
  given(:question) { create :question, user: author }

  describe 'Author' do
    background do
      sign_in(author)
      visit question_path(question)
      click_on 'Edit Question'
    end

    scenario 'tries to edit the question', js: true do
      fill_in 'Title', with: 'New Title'
      click_on 'Save'

      expect(page).to have_content('New Title')
    end

    scenario 'tries to edit the question with errors', js: true do
      fill_in 'Title', with: ''
      click_on 'Save'

      expect(page).to have_content("Title can't be blank")
    end

    scenario 'tries to edit the question with attached file', js: true do
      within '.question' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

  end

  scenario 'Not an author tries to edit the question' do
    sign_in(not_an_author)
    visit question_path(question)

    expect(page).to_not have_content('Edit Question')
  end
end
