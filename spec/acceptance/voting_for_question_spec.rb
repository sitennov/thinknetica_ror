require_relative 'acceptance_helper'

feature 'Voting for the question', %q{
  In order to vote for a question up or down
  As an authenticated user
  I want to be able to vote for the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User votes for the question up' do
    expect(find('.vote-count')).to have_content '0'

    within "#question-#{question.id}" do
      click_on 'up vote'
      expect(find('.vote-count')).to have_content '1'
    end
  end

  scenario 'User votes for the question down'
end
