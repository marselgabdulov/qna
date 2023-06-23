Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true, only: %i(create update destroy) do
      post 'mark_as_best', on: :member
    end
  end

  delete 'attachments/:id/purge', to: 'attachments#purge', as: 'purge_attachment'
end
