Rails.application.routes.draw do

  root 'questions#index'
  devise_for :users

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      delete :vote_reset
    end
  end

  resources :questions, shallow: true do
    concerns :votable
    resources :answers, shallow: true do
      concerns :votable
      patch :set_best, on: :member
    end
    put :vote_up, on: :member
  end

  resources :attachments, only: [:destroy]
end
