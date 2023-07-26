require 'sphinx_helper'

feature 'User can use search', %q(
  In order to find information he needs
  As guest
  I'd like to be able to use search
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:question_comment) { create(:comment, commentable: question) }

  background { visit root_path }

  scenario 'user searches All', sphinx: true do
    ThinkingSphinx::Test.run do
      select 'All', from: :resource
      fill_in 'Search', with: user.email
      click_on 'Search'

      expect(page).to have_content user.email
    end
  end

  scenario 'user searches Question', sphinx: true do
    ThinkingSphinx::Test.run do
      select 'Question', from: :resource
      fill_in 'Search', with: question.title
      click_on 'Search'

      expect(page).to have_content '1 result'
      expect(page).to have_content question.title
    end
  end

  scenario 'user searches Answer', sphinx: true do
    ThinkingSphinx::Test.run do
      select 'Answer', from: :resource
      fill_in 'Search', with: answer.body
      click_on 'Search'

      expect(page).to have_content '1 result'
      expect(page).to have_content answer.body
    end
  end

  scenario 'user searches Comment', sphinx: true do
    ThinkingSphinx::Test.run do
      select 'Comment', from: :resource
      fill_in 'Search', with: question_comment.body
      click_on 'Search'

      expect(page).to have_content '1 result'
      expect(page).to have_content question_comment.body
    end
  end

  scenario 'user searches Comment', sphinx: true do
    ThinkingSphinx::Test.run do
      select 'User', from: :resource
      fill_in 'Search', with: user.email
      click_on 'Search'

      expect(page).to have_content '1 result'
      expect(page).to have_content user.email
    end
  end
end
