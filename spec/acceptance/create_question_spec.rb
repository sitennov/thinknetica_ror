require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order to be able to ask question
  As an user
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user create the question with valid attributes' do
    sign_in(user)
    visit questions_path

    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_on 'Create'

    expect(page).to have_content I18n.t('questions.create.created')

    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text text'
  end

  scenario 'Authenticated user create the question with invalid attributes' do
    sign_in(user)
    visit questions_path

    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: ''
    click_on 'Create'

    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'Non-authenticated user ties to create question' do
    visit questions_path
    expect(page).to_not have_link 'Ask question'
  end

  context 'mulitple sessions' do
    scenario "question appears on another user's page", js:true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
        click_on 'Create'

        expect(page).to have_content I18n.t('questions.create.created')
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end
end
