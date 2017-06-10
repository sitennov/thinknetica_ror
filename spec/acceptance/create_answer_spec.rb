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

    visit question_path(question)

    fill_in 'Body', with: 'text text text'
    click_on 'Create'

    expect(current_path).to eq question_path(question)

    within '.answers' do
      expect(page).to have_content 'text text text'
    end
  end

  scenario 'Authenticated user create the answer with invalid attributes' do
    sign_in(user)

    visit question_path(question)

    fill_in 'Body', with: ''
    click_on 'Create'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content I18n.t('answers.create.not_created')
  end
end
