require_relative 'acceptance_helper'

feature 'view question and answers', %q{
  In order to view the answers to questions
  As a user
  I want to be able to view the questions and answers to it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 2, question: question) }

  scenario 'Authenticated user view question and answers' do
    sign_in(user)
    answers
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario 'Non-authenticated user view question and answers' do
    answers
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
