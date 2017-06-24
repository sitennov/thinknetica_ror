require_relative 'acceptance_helper'

feature 'Answer deleting', %q{
  In order to delete your answer
  As an author of answer
  I want to be able to deleting my answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question)}

  scenario 'User tries to delete his answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete'

    expect(page).to_not have_content answer.body
  end

  scenario 'User tries to delete another user\'s answer', js: true do
    other_user = create(:user)
    sign_in(other_user)
    visit question_path question

    expect(page).to_not have_content 'Delete'
  end
end
