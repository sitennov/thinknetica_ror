require_relative 'acceptance_helper'

feature 'Voting for the answer', %q{
  In order to vote for a answer up or down
  As an authenticated user
  I want to be able to vote for the answer
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Author of answer can not vote for it', js:true do
    sign_in(user)

    visit question_path(question)

    within "#answer-#{answer.id}" do
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
      expect(page).to_not have_link 'reset'
    end
  end

end
