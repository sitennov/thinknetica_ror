require_relative 'acceptance_helper'

feature 'Comments for the answer', %q{
  In order to discuss the answer
  As an authenticated user
  I want to be able to leave comments
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Non-authenticated user', js:true do
    scenario 'Non-authenticated user tries to add comment'
  end

  describe 'Authenticated user', js:true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Sees link for add comment'
    scenario 'Leaves a valid comment'
    scenario 'Leaves a invalid comment'
  end

  context 'multiple sessions'
end
