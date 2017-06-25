Rails.application.routes.draw do

  root 'questions#index'
  devise_for :users

  resources :questions, shallow: true do
    resources :answers, shallow: true do
      patch :set_best, on: :member
    end
  end
end
