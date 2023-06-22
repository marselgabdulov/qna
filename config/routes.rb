Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true, only: [:create, :update, :destroy, :mark_as_best] do
      post 'mark_as_best', on: :member
    end
  end
end
