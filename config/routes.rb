Rails.application.routes.draw do

   devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations:'users/registrations'
  }
  
  resource :pages, only: [:show]

  
  root to: 'workspaces#index'
  resources :workspaces do
    resource :users_workspaces
    resource :channels, only: %i[new create]
    resources :channels, only: [:show]
  end

  resources :channels, except: %i[show new create] do
    resource :users_channels
    resources :messages
  end
  
  # 信件測試

  if Rails.env.development?
     mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  

end
