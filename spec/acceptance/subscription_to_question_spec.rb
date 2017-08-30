require_relative 'acceptance_helper'

feature 'User subscribe/unsubscribe to the question', %q{
  In order to follow the answers to the questions
  As a authenticated user
  I want to be able subscribe to the question
} do

  describe 'Subscribe to question' do
    given!(:user) { create(:user) }
    given!(:question) { create(:question) }

    scenario 'Authenticated user subscribe to the question', js: true do
      sign_in(user)
      visit question_path(question)
      click_link 'Subscribe'

      expect(page).to have_link 'Unsubscribe'
    end

    scenario 'Non-authenticated user try to subscribe to the question', js: true do
      visit question_path(question)

      expect(page).to_not have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end

  describe 'Unsubscribe to question' do
    given!(:user) { create(:user) }
    given!(:question) { create(:question) }
    given!(:subscription) { create(:subscription, question: question, user: user) }

    scenario 'Authenticated user unsubscribe to the question', js: true do
      sign_in(user)
      visit question_path(question)

      click_link 'Unsubscribe'

      expect(page).to have_link 'Subscribe'
    end

    scenario 'Non-authenticated user try to unsubscribe to the question', js: true do
      visit question_path(question)

      expect(page).to_not have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end
end
