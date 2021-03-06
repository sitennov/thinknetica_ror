require_relative 'acceptance_helper'

feature 'View questions', %q{
  In order to find the answer to your question
  As a user
  I want to be able to view the questions
} do

  given!(:questions) { create_list(:question, 2) }

  scenario 'User view questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content(question.title)
    end
  end
end
