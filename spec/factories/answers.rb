FactoryGirl.define do
  factory :answer do
    body "MyText"
    question { create(:question) }
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    user
  end
end
