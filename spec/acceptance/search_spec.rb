require_relative 'acceptance_helper'

feature 'Search all', %q{
  In order to find questions, answers, users, comments
  As a guest or authenticated user
  I want to be able recieve the results of searching
} do

  given!(:question) { create(:question, title: 'something') }
  given!(:answer) { create(:answer, body: 'something') }
  given!(:comment) { create(:comment, commentable: question, body: 'something') }
  given!(:user) { create(:user, email: "something@mail.ru") }

  scenario 'Guest searching all', js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      select 'All', from: 'search_area'
      fill_in 'query', with: 'something'
      click_on 'Submit'

      expect(page).to have_content question.title
      expect(page).to have_content answer.body
      expect(page).to have_content comment.body
      expect(page).to have_content user.email
    end
  end

  %w(Questions Answers Comments Users).each do |attr|
    scenario "Guest searching for #{attr}", js: true do
      ThinkingSphinx::Test.run do
        visit root_path

        select attr, from: 'search_area'
        fill_in 'query', with: 'something'
        click_on 'Submit'

        expect(page).to have_content attr.singularize
      end
    end
  end
end
