FactoryGirl.define do
  factory :question do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.sentence }
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    user
  end
end
