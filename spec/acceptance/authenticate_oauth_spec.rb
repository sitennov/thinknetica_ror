require_relative 'acceptance_helper'

feature 'Authenticate using oauth', %q{
  In order to start the session
  As an authenticated user
  I'd like to be able to authenticate using social networks
} do

  given!(:user) { create(:user) }

  describe 'Authenticate user using Facebook', js: true do
    scenario 'New user first time try to login using facebook' do
      clear_emails
      auth = mock_auth_hash(:facebook)

      visit new_user_session_path
      click_on 'Sign in with Facebook'

      expect(page).to have_content('You have to confirm your email address before continuing.')

      open_email(auth[:info][:email])

      current_email.click_link 'Confirm my account'
      expect(page).to have_content('Your email address has been successfully confirmed')

      visit new_user_session_path
      click_on 'Sign in with Facebook'

      expect(page).to have_content('Successfully authenticated from Facebook account.')
    end

    scenario 'Registred user using Facebook try again to authenticate using Facebook' do
      auth = mock_auth_hash(:facebook, user.email)
      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      click_on 'Sign in with Facebook'

      expect(page).to have_content('Successfully authenticated from Facebook account')
    end
  end

  describe 'Authenticate user using Twitter', js: true do
    scenario 'New user first time try to login using twitter' do
      clear_emails
      visit new_user_session_path
      mock_auth_hash(:twitter, nil)
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Email is required to compete sign up'
      fill_in 'Email', with: 'twitter@mail.ru'
      click_on 'Submit'

      expect(page).to have_content('You have to confirm your email address before continuing.')

      open_email('twitter@mail.ru')

      current_email.click_link 'Confirm my account'
      expect(page).to have_content('Your email address has been successfully confirmed.')

      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content('Successfully authenticated from Twitter account')
    end

    scenario 'Registred user using Facebook try again to authenticate using Twitter', js: true do
      auth = mock_auth_hash(:twitter, user.email)
      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content('Successfully authenticated from Twitter account')
    end
  end
end
