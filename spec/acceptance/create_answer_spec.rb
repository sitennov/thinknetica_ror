require 'rails_helper'

feature 'Create answer', %q{
  To answer questions
  As an authenticated user
  I want to be able to create an answer to a question
} do

  scenario 'Authenticated user create the answer' do
    User.create!(email: 'sitennov@mail.ru', password: '123654')

    visit new_user_session_path
    fill_in 'Email', with: 'sitennov@mail.ru'
    fill_in 'Password', with: '123654'
    click_on 'Log in'

    # expect(page).to have_content I18n.t('answers.create.created')
  end

  scenario 'Non-authenticated user tries to answer the question'
end
