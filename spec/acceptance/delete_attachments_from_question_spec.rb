require_relative 'acceptance_helper'

feature 'Delete files from question', %q{
  I want to delete attached file
  As an question's author
  I want to be able to delete attachments
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User deletes his attachments files', js: true do
    within "li#attachment-#{attachment.id}" do
      click_on 'remove attachment'

      expect("ul.question-files").to_not have_link "attachment-#{attachment.id}"
    end
  end

  scenario 'User tries to delete another user\'s attachments', js:true do
    expect("li#attachment-#{attachment.id}").to_not have_link 'remove attachment'
  end
end
