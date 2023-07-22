Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  root to: 'questions#index'

  post 'users/noemail_signup', to: 'users#noemail_signup', as: :noemail_signup

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      post :revote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, concerns: :votable do
      member do
        post :mark_as_best
      end
      resources :comments, only: :create
    end
    resources :comments, only: :create
  end

  resources :attachments, only: :destroy

  resources :rewards, only: :index

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: %i[index]
    end
  end
end
