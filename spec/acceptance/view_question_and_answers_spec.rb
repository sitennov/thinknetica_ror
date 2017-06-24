require_relative 'acceptance_helper'

feature 'view question and answers', %q{
  In order to view the answers to questions
  As a user
  I want to be able to view the questions and answers to it
} do

  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 2, question: question) }

  scenario 'View question and reply to it' do
    answers
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    page.all('.panel-body').each_with_index do |el, i|
      expect(el).to have_content(answers[i].body)
    end
  end
end
