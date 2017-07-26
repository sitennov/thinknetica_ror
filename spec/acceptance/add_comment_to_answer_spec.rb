require_relative 'acceptance_helper'

feature 'Comments for the answer', %q{
  In order to discuss the answer
  As an authenticated user
  I want to be able to leave comments
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Non-authenticated user', js:true do
    scenario 'Non-authenticated user tries to add comment' do
      visit question_path(question)

      within "#answer-#{answer.id}" do
        expect(page).to_not have_content 'Leave a comment'
      end
    end
  end

  describe 'Authenticated user', js:true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Sees link for add comment' do
      within "#answer-#{answer.id}" do
        expect(page).to have_link 'Leave a comment'
      end
    end

    scenario 'Leaves a valid comment' do
      within "#answer-#{answer.id}" do
        click_on 'Leave a comment'
        expect(page).to have_content 'Your comment'
        fill_in 'Your comment', with: 'My comment'
        click_on 'Add comment'
        expect(page).to have_content 'My comment'
      end
    end

    scenario 'Leaves a invalid comment' do
      within "#answer-#{answer.id}" do
        click_on 'Leave a comment'
        expect(page).to have_content 'Your comment'
        fill_in 'Your comment', with: ''
        click_on 'Add comment'
        expect(page).to have_content ''
      end
    end
  end

  context 'multiple sessions'
end
