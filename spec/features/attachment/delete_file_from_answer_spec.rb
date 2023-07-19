require 'rails_helper'

feature 'User can delete files from answer', "
  In order to delete additional information
  As file's author
  I'd like to be able to delete attached files
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }

  background do
    answer.files.attach(create_file_blob(filename: 'test.png'))
  end

  it_behaves_like 'file deleting features' do
    given(:file_selector) { "#answer-#{answer.id}" }
  end
end
