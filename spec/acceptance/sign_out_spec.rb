require 'rails_helper'

feature 'User sign out', %q{
  In order to complete the session
  As an authenticate user
  I want be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign in' do
    sign_in(user)

    # save_and_open_page
    click_on 'Sign out'

    expect(page).to have_content I18n.t('devise.sessions.signed_out')
    expect(current_path).to eq root_path
  end
end
