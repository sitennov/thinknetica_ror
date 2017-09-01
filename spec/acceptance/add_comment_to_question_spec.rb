require_relative 'acceptance_helper'

feature 'Comments for the question', %q{
  In order to discuss the question
  As an authenticated user
  I want to be able to leave comments
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Non-authenticated user', js:true do
    scenario 'Non-authenticated user tries to add comment' do
      visit question_path(question)

      within "#question-#{question.id}" do
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
        within "#question-#{question.id}" do
          expect(page).to have_link 'Leave a comment'
        end
      end

      scenario 'Leaves a valid comment' do
        within "#question-#{question.id}" do
          click_on 'Leave a comment'
          expect(page).to have_content 'Your comment'
          fill_in 'Your comment', with: 'My comment'
          click_on 'Add comment'
          expect(page).to have_content 'My comment'
        end
      end

      scenario 'Leaves a invalid comment' do
        within "#question-#{question.id}" do
          click_on 'Leave a comment'
          expect(page).to have_content 'Your comment'
          fill_in 'Your comment', with: ''
          click_on 'Add comment'
          expect(page).to have_content "Body can't be blank"
        end
      end
    end

    context 'mulitple sessions' do
      scenario "question appears on another user's page", js:true do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          within "#question-#{question.id}" do
            click_on 'Leave a comment'
            fill_in 'Your comment', with: 'comment comment comment'
            click_on 'Add comment'
          end

          within "#question-#{question.id} .comments-list" do
            expect(page).to have_content 'comment comment comment'
          end
        end

        Capybara.using_session('guest') do
          within "#question-#{question.id} .comments-list" do
            expect(page).to have_content 'comment comment comment'
          end
        end
      end
    end
  end
end
