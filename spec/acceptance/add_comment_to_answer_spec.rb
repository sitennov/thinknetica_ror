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
    context 'add comment' do
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
  end

  context 'multiple sessions' do
    scenario "answer appears on another user's page", js:true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within "#answer-#{answer.id}" do
          click_on 'Leave a comment'
          fill_in 'Your comment', with: 'comment comment comment'
          click_on 'Add comment'
        end

        within "#answer-#{answer.id} .answer-comments .comments-list" do
          expect(page).to have_content 'comment comment comment'
        end
      end

      Capybara.using_session('guest') do
        within "#answer-#{answer.id} .answer-comments .comments-list" do
          expect(page).to have_content 'comment comment comment'
        end
      end
    end
  end
end
