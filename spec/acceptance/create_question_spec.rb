require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask the question
} do

  scenario 'Authenticated user create the question' do
    User.create!(email: 'sitennov@mail.ru', password: '123654')

    visit new_user_session_path
    fill_in 'Email', with: 'sitennov@mail.ru'
    fill_in 'Password', with: '123654'
    click_on 'Log in'

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_on 'Create'

    expect(page).to have_content I18n.t('questions.create.created')
  end

  scenario 'Non-authenticated user ties to create question' do

    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
