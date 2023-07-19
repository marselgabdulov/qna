shared_examples 'file deleting features' do
  shared_examples 'can not delete attached file' do
    scenario 'can not see delete file link' do
      within file_selector.to_s do
        expect(page).to_not have_link 'Delete File'
      end
    end
  end
  context 'as user' do
    context 'as author', :js do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'deletes attached file' do
        within file_selector.to_s do
          expect(page).to have_content 'test.png'
          click_on 'Delete File'
          page.driver.browser.switch_to.alert.accept
        end

        expect(page).to_not have_link 'Delete File'
        expect(page).to_not have_content 'test.png'
      end
    end

    context 'not author' do
      background do
        sign_in(another_user)
        visit question_path(question)
      end

      it_behaves_like 'can not delete attached file'
    end
  end

  context 'as guest' do
    background { visit question_path(question) }

    it_behaves_like 'can not delete attached file'
  end
end
