require 'rails_helper'

feature 'User can see list of questions', %q{
  In order to get answer from a community
  As an authorized user or a guest user
  I'd like to be able to see the list of questions
} do

  given(:user) { create(:user) }
  before { create_list(:question, 3) }

  scenario 'Authorised user tries to see list of questions' do
    sign_in(user)
    visit questions_path
    expect(page).to have_content('MyString')
  end

  scenario 'Unathorised user tries to see list of questions' do
    visit questions_path
    expect(page).to have_content('MyString')
  end
end
