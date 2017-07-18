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

    within "#answer-#{answer.id} .votes" do
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
      expect(page).to_not have_link 'reset'
    end
  end

  scenario 'Nobody can vote for answer more than 1 time', js:true do
    sign_in(user2)
    visit question_path(question)

    within "#answer-#{answer.id} .votes" do
      click_on '+'
      click_on '+'
      expect(page).to have_content 1
    end
  end

  scenario 'User votes for the answer up', js:true do
    sign_in(user2)
    visit question_path(question)

    within "#answer-#{answer.id} .votes" do
      click_on '+'
      expect(page).to have_content 1
    end
  end

  scenario 'User votes for the answer down', js:true do
    sign_in(user2)
    visit question_path(question)

    within "#answer-#{answer.id} .votes" do
      click_on '-'
      expect(page).to have_content -1
    end
  end

  scenario 'User cancels his vote', js:true do
    sign_in(user2)
    visit question_path(question)

    within "#answer-#{answer.id} .votes" do
      expect(page).to have_content 0
      click_on '+'
      expect(page).to have_content 1
      click_on 'vote reset'
      expect(page).to have_content 0
    end
  end
end
