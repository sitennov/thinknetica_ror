FactoryGirl.define do
  factory :user do
    before(:create, &:skip_confirmation!)

    email { Faker::Internet.email }
    password '123123'
    password_confirmation '123123'
  end
end
