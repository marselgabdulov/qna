
require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:author) { create(:user) }
  given!(:not_an_author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit Answer'
  end

  describe 'Authenticated user' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'edits his answer', js: true do
      within '.answers' do
        click_on 'Edit Answer'
        fill_in 'Your Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with attached file', js: true do
      within '.answers' do
        click_on 'Edit Answer'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his answer with errors', js: true do
      within '.answers' do
        click_on 'Edit Answer'
        fill_in 'Your Answer', with: ''
        click_on 'Save'

        expect(page).to have_content("Body can't be blank")
      end
    end
  end

  scenario "tries to edit other user's question" do
    sign_in(not_an_author)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_content('Edit Answer')
    end
  end
end
