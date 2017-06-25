require_relative 'acceptance_helper'

feature 'Set best answer', %q{
  In order to set best answer
  As an author of question
  I want to be able from choose the best answer to my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  scenario 'Non authenticated user trying to set best answer', js: true do
    other_user = create(:user)
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_button 'Set best'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'can set best asnwer', js: true do
      within "#answer-#{answers.first.id}" do
        click_on 'Set best'
        expect(page).to have_content 'BEST'
      end
    end
    scenario 'can set another answer as best', js: true do
      within "#answer-#{answers.first.id}" do
        click_on 'Set best'
        expect(page).to have_content 'BEST'
      end
      within "#answer-#{answers.second.id}" do
        click_on 'Set best'
        expect(page).to have_content 'BEST'
      end
    end
    scenario 'see best answer first in answers list', js: true do
      within "#answer-#{answers.third.id}" do
        click_on 'Set best'
      end
      expect(page).to have_content 'Answers'
      best_tr = page.find('.answr').first(:xpath, 'tr[1]')
      within best_tr do
        expect(page).to have_content 'BEST'
      end
    end

  end
end
