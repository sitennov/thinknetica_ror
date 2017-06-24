require 'rails_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to Edit' do
      visit question_path(question)

      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'try to edit his answer', js: true do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'Unauthenticated user try to edit question' do
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario 'try to edit other user\'s question' do
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'trying to edit another user\'s answer' do
    other_user = create(:user)
    sign_in(other_user)
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
