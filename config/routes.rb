Rails.application.routes.draw do

  devise_for :users
  resource :pages
  root to: 'pages#index'
end
