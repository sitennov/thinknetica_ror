require 'rails_helper'

feature 'Create answer', %q{
  To answer questions
  As an authenticated user
  I want to be able to create an answer to a question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user create the answer' do
    sign_in(user)

    visit questions_path
    click_on question.title

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    fill_in 'Body', with: 'text text text'
    click_on 'Create'

    within '.answer-items' do
      expect(page).to have_content 'text text text'
    end
  end
end
