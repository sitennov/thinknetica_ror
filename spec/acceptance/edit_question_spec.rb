require 'rails_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of question
  I want to be able to edit my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user trying to edit question' do
    visit questions_path
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit questions_path
    end

    scenario 'sees link to Edit' do
      within '.question-item' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'trying to edit his question with valid attributes', js: true do
      click_on 'Edit'

      within '.question-item' do
        fill_in 'Question title', with: 'Test question111'
        fill_in 'Question body', with: 'text text text111'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to have_content 'Test question111'
        expect(page).to have_content 'text text text111'
      end
    end

    scenario 'trying to edit his question with invalid attributes', js: true do
      click_on 'Edit'

      within '.question-item' do
        fill_in 'Question title', with: ''
        fill_in 'Question body', with: ''
        click_on 'Save'

        expect(page).to have_content 'Body can\'t be blank'
      end
    end
  end
end
