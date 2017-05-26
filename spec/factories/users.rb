FactoryGirl.define do
  sequence :email { |n| "user#{n}@test.ru" }

  factory :user do
    email
    password '123654'
    password_confirmation '123654'
  end
end
