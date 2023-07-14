require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authorized user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user asks question' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'without errors' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'some text'
      click_on 'Save'

      expect(page).to have_content 'Your question was successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'some text'
    end

    scenario 'whith errors' do
      click_on 'Save'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'with attached files' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'some text'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Save'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'and creates reward' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'some text'

      within '#reward' do
        fill_in 'Reward Name', with: 'Best Answer'
        attach_file 'Reward Image', "#{Rails.root}/spec/fixtures/reward.png"
      end
      click_on 'Save'

      expect(page).to have_content 'Best Answer'
    end
  end

  context 'multiple sessions' do
    scenario 'question appears on another user page', js: true do
      Capybara.using_session('authenticated user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('unauthenticated user') do
        visit questions_path
      end

      Capybara.using_session('authenticated user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'

        click_on 'Save'

        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('unauthenticated user') do
        expect(page).to have_content 'Test question'
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
