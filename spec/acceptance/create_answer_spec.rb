require 'rails_helper'

feature 'Create answer', %q{
  To answer questions
  As an authenticated user
  I want to be able to create an answer to a question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user create the answer with valid attributes', js: true do
    sign_in(user)

    visit questions_path
    click_on question.title

    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'
    click_on 'Create'

    expect(current_path).to eq question_path(question)

    within '.answers' do
      expect(page).to have_content 'My answer'
    end
  end
end
