require 'rails_helper'

feature 'Siging in', %q{
  In order to be able ask questions
  As an user
  I want be able to sign in
} do

  scenario 'Registered user try to sign in' do
    User.create!(email: 'sitennov@mail.ru', password: '123654')

    visit new_user_session_path
    fill_in 'Email', with: 'sitennov@mail.ru'
    fill_in 'Password', with: '123654'
    click_on 'Sign in'

    expect(page).to have_content 'Signed to Successfolly.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registred user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'sitennov@mail.ru'
    fill_in 'Password', with: '123654'
    click_on 'Sign in'

    expect(page).to have_content 'Invalid email or password.'
    expect(current_path).to eq new_user_session_path
  end
end
