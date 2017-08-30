require_relative 'acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of question
  I want to be able to edit my question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user trying to edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js:true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to Edit' do
      within "#question-#{question.id}" do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'trying to edit his question with valid attributes' do
      within "#question-#{question.id} .question" do
        click_on 'Edit'
        fill_in 'Question title', with: 'Test question111'
        fill_in 'Question body', with: 'text text text111'
        click_on 'Save'

        visit question_path(question)
        expect(page).to_not have_content question.title
        expect(page).to have_content 'Test question111'
      end
    end

    scenario 'trying to edit his question with invalid attributes' do
      within "#question-#{question.id}" do
        click_on 'Edit'
        fill_in 'Question title', with: ''
        fill_in 'Question body', with: ''

        click_on 'Save'

        expect(page).to have_content 'Body can\'t be blank'
      end
    end

    scenario 'tries to edit his question with invalid body' do
      within '.question' do
        click_on 'Edit'
      end
      fill_in 'Question title', with: ''
      fill_in 'Question body', with: ''
      click_on 'Save'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'trying to edit another user\'s question' do
    other_user = create(:user)
    sign_in(other_user)
    visit question_path(question)

    within "#question-#{question.id}" do
      expect(page).to_not have_link 'Edit'
    end
  end
end
