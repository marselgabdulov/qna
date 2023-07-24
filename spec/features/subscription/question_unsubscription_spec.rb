require 'rails_helper'

feature 'User can unsubscribe from the question', "
  In order to not receive notifications about new answers
  As user
  I'd like to be able to unsubscribe
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:subscription) { create(:subscription, user: user, question: question) }

  scenario 'user unsubscribes', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Unsubscribe'

    expect(page).to_not have_link 'Unsubscribe'
  end

  scenario 'guest can not see unsubscribe link' do
    visit question_path(question)

    expect(page).to_not have_link 'Unsubscribe'
  end
end
