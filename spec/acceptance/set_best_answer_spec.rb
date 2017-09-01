require_relative 'acceptance_helper'

feature 'Set best answer', %q{
  In order to set best answer
  As an author of question
  I want to be able from choose the best answer to my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  scenario 'Non authenticated user trying to set best answer', js: true do
    other_user = create(:user)
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_button 'Set best'
  end

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'trying set best answer' do
      within "#answer-#{answers.first.id}" do
        click_on 'Set best'
      end
      expect(page).to have_selector('.answer-best')
      expect(page).to have_selector('.answer-best', count: 1)
    end

    scenario 'trying set best answer of another user' do
      within "#answer-#{answers.last.id}" do
        click_on 'Set best'
      end

      within ".answers" do
        expect(find('.answer:first-child')).to have_selector('.answer-best')
      end
    end
  end
end
