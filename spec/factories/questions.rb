FactoryGirl.define do
  sequence(:title) { |n| "MyTitle #{n}" }
  sequence(:body) { |n| "MyBody #{n}" }

  factory :question do
    title
    body
    user { create(:user) }
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
