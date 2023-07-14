Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  root to: 'questions#index'

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

  delete 'attachments/:id/purge', to: 'attachments#purge', as: 'purge_attachment'

  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
