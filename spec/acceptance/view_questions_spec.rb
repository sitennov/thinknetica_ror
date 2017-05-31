require 'rails_helper'

feature 'View questions', %q{
  In order to find the answer to your question
  As a user
  I want to be able to view the questions
} do

  given(:questions) { create_list(:question, 5) }

  scenario 'User view questions' do
    questions

    visit questions_path

    expect(page).to have_selector('.questions-list')

    page.all('.question-item').each_with_index do |el, i|
      expect(el['href']).to have_content(question_path(questions[i]))
      expect(el).to have_content(questions[i].title)
    end
  end

end
