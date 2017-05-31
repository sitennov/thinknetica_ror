require 'rails_helper'

feature 'Create answer', %q{
  To answer questions
  As an authenticated user
  I want to be able to create an answer to a question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { attributes_for(:answer) }

  scenario 'Authenticated user create the answer' do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    fill_in 'Your Answer', with: 'My answer....'
    click_on 'Create Answer'

    # save_and_open_page

    expect(page).to have_content I18n.t('answers.create.created')
    expect(page).to have_content answer[:body]
  end

  scenario 'Non-authenticated user tries to answer the question' do
    visit question_path(question)

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
