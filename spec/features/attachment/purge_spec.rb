require 'rails_helper'

feature 'Author of the question or the answer can delete attached files', %q{
  In order to get the question or the answer cleaner
  As an author of the question or the answer
  I'd like to be able to delete attached files
} do

  given!(:author) { create :user }
  given!(:not_an_author) { create :user }
  given!(:question) { create :question, :with_file, user: author }
  given!(:answer) { create :answer, :with_file, user: author, question: question  }

  describe 'Author' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'tries to delete the question file', js: true do
      within '.question-files' do
        click_on 'delete file'
        expect(page).not_to have_link('default.jpg')
      end
    end

    scenario 'tries to delete the answer file', js: true do
      within '.answer-files' do
        click_on 'delete file'
        expect(page).not_to have_link('default.jpg')
      end
    end
  end

  scenario 'Not an author tries to delete the file' do
    sign_in(not_an_author)
    visit question_path(question)

    expect(page).not_to have_link('delete file')
  end
end
