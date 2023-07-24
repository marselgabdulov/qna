require 'rails_helper'

feature 'User can subscribe for question', "
  In order to receive notifications about new answers
  As user
  I'd like to be able to subscribe
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'user subscribes', :js do
    sign_in(user)
    visit question_path(question)
    click_on 'Subscribe'

    expect(page).to_not have_link 'Subscribe'
  end

  scenario 'guest can not see subscribe link' do
    visit question_path(question)

    expect(page).to_not have_link 'Subscribe'
  end
end
