Rails.application.routes.draw do
  
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations:'users/registrations'
  }



    get '/users/profiles/edit', to: 'profiles#edit', as: 'edit_profiles'
    get '/users/profiles/avatar',to: 'profiles#avatar_url', as: 'avatar_url_profiles'
    resource :profiles, path: "/users/profiles/:id", except: [:edit,:avatar_url]
  resource :pages do
    get :index
    get :login
    get :validate
  end
    get '/workspaces/:workspace_id/workspace_users',to: 'channels#workspace_users',as: 'workspace_users'
  root to: 'pages#index'
  resources :workspaces do
    resource :users_workspaces
    resource :channels, only: %i[new create]
    resources :channels, only: [:show] do
      # resources :threads, only: [:show]
    end
    resource :invitations, only: :create do
      get :accept
    end
    resources :directmsgs, only: [:show]
    resources :uploadedfiles, only: %i[index create] do 
      member do
        post :share
      end
    end
    
    resource :draft, only: [:show]
  end

  mount Shrine.download_endpoint => "/attachments"
  
  resources :channels, except: %i[show new create] do
    resource :users_channels do 
      post :invite
    end
    resources :messages do
      resource :threads, only: [:create, :show]
    end
  end
  
  resources :directmsgs, only: [:show] do
    resources :messages, only: [:create] do
      resource :threads, only: [:create, :show]
    end
  end

  resources :messages, only: [:show] do 
    collection do
      post 'add'
    end

    member do
      post 'emoji'
    end

  end
  
  # webhook endpoint, /webhook/channels/:id/github
  namespace :webhook do
    post 'channels/:id/github', to: 'github#payload'
  end

  # 信件測試
  if Rails.env.development? || Rails.env.staging?
     mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

end
