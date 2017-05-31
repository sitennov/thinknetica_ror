require 'rails_helper'

feature 'view question and answers', %q{
  In order to view the answers to questions
  As a user
  I want to be able to view the questions and answers to it
} do

  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 3, question: question) }

  scenario 'View question and reply to it' do

  end

end
