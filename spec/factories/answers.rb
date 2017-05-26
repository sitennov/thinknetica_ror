FactoryGirl.define do
  factory :answer do
    body "MyText"
    question { create(:question) }
    user { create(:user) }
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
