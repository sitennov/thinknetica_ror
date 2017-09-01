require 'sidekiq/web'

Rails.application.routes.draw do

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    post '/users/auth/sign_up' => 'omniauth_callbacks#sign_up'
  end

  root 'questions#index'

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      delete :vote_reset
    end
  end

  concern :commentable do
    member do
      post :comment
    end
  end

  resources :questions, shallow: true do
    concerns :votable
    concerns :commentable
    resources :answers, only: [:create, :update, :destroy] do
      concerns :votable
      concerns :commentable
      patch :set_best, on: :member
    end
    put :vote_up, on: :member
  end

  resources :attachments, only: [:destroy]
  resources :subscriptions, only: [:create, :destroy]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, shallow: true do
        resources :answers
      end
    end
  end

  get '/search' => 'search#search'

  mount ActionCable.server => '/cable'
end
