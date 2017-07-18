require_relative 'acceptance_helper'

feature 'Voting for the question', %q{
  In order to vote for a question up or down
  As an authenticated user
  I want to be able to vote for the question
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'User votes for the question up', js:true do
    sign_in(user2)
    visit question_path(question)

    within '.votes' do
      click_on '+'
      expect(page).to have_content '1'
    end
  end

  scenario 'Nobody can vote for question more than 1 time', js:true do
    sign_in(user2)
    visit question_path(question)

    within('.votes') do
      click_on '+'
      click_on '+'
      expect(page).to have_content '1'
    end
  end

  scenario 'User votes for the question down', js:true do
    sign_in(user2)
    visit question_path(question)

    within '.votes' do
      click_on '-'
      expect(page).to have_content '0'
    end
  end

  scenario 'User cancels his vote', js:true do
    sign_in(user2)
    visit question_path(question)

    within '.votes' do
      expect(page).to have_content '0'
      click_on '+'
      expect(page).to have_content '1'
      click_on 'vote reset'
      expect(page).to have_content '0'
    end
  end
end
