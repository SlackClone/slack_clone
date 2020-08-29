Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  resource :pages

  resources :workspaces do
    resource :channels, only: [:new, :create, :update]
    resources :channels, only: [:show]
  end

  resources :channels, except: [:show, :new, :create, :update] do
    resource :users_channels
    resources :messages
  end
  root to: 'workspaces#index'

end
