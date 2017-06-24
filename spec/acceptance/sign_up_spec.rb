require_relative 'acceptance_helper'

feature 'Siging up', %q{
  In order to be able to ask questions and to create answers to questions
  As a user
  I want to be able to sign up
} do

  given(:user) { attributes_for(:user) }

  scenario 'User signing up' do
    visit new_user_registration_path

    fill_in 'Email', with: user[:email]
    fill_in 'Password', with: user[:password]
    fill_in 'Password confirmation', with: user[:password_confirmation]
    click_on 'Sign up'

    expect(page).to have_content I18n.t('devise.registrations.signed_up')
    expect(current_path).to eq root_path
  end
end
