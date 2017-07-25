require_relative 'acceptance_helper'

feature 'Delete files from answer', %q{
  I want to delete attached file
  As an answer's author
  I want to be able to delete attachments
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User deletes his attachments files', js: true do
    within "li#attachment-#{attachment.id}" do
      click_on 'Remove attachment'

      expect("#answer-#{answer.id}").to_not have_link "attachment-#{attachment.id}"
    end
  end

  scenario 'User tries to delete another user\'s attachments', js:true do
    expect("#answer-#{answer.id}").to_not have_link 'remove attachment'
  end
end
