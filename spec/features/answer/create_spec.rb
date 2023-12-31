require 'rails_helper'

feature 'Authorized user can create answer', %q{
  In order to get answer to a community
  As an authorized user
  I'd like to be able to answer the question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Authenticated user create answer', js: true do
    within 'form.new-answer' do
      fill_in 'Your Answer', with: 'My answer'
      click_on 'Create Answer'
    end

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'My answer'
    end
  end

  scenario 'Authenticated user creates answer with attached file', js: true do
    within 'form.new-answer' do
      fill_in 'Your Answer', with: 'My answer'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create Answer'
    end

    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end

  scenario 'Authenticated user creates answer with errors', js: true do
    within 'form.new-answer' do
      click_on 'Create Answer'
    end

    expect(page).to have_content "Body can't be blank"
  end

  context 'multiple sessions' do
    scenario 'answer appears on another user page', js: true do
      Capybara.using_session('authenticated user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('unauthenticated user') do
        visit question_path(question)
      end

      Capybara.using_session('authenticated user') do
        fill_in 'Your Answer', with: 'My answer'

        click_on 'Create Answer'

        expect(page).to have_content 'My answer'
      end

      Capybara.using_session('unauthenticated user') do
        expect(page).to have_content 'My answer'
      end
    end
  end
end
