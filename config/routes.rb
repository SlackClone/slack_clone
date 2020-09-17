Rails.application.routes.draw do

   devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations:'users/registrations'
  }
  
  resource :pages do
    get :index
    get :login
    get :validate
  end
  
  # get '/message/share/:id', to: 'channels#share', as:'channel_share_message'
  # post '/message/share/:id/add', to: 'channels#add', as:'channel_share'
  
  root to: 'pages#index'
  resources :workspaces do
    resource :users_workspaces
    resource :channels, only: %i[new create]
    resources :channels, only: [:show]
    resource :invitations, only: :create do
      get :accept
    end
    resources :directmsgs, only: [:show]
  end

  resources :channels, except: %i[show new create] do
    resource :users_channels
    resources :messages
  end
  
  namespace :api do
    namespace :v1 do
      resources :users_workspaces, only: [:index]
    end
  end

  resources :directmsgs, only: [:show] do
    resources :messages, only: [:create]
  end

  resources :messages, only: [:show] do 
    post 'share'
    post 'add'
  end
  
  # 信件測試
  if Rails.env.development?
     mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  

end
