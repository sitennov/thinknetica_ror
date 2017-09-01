FactoryGirl.define do
  factory :authorization do
    user nil
    provider "Fb"
    uid "UserId"
  end
end
